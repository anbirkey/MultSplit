function answer = dip_setup_2l_dlg()

    % 1. Create the figure
    fig = uifigure('Name', 'Dip Setup', 'Position', [500 400 450 300], ...
        'WindowStyle', 'modal', 'Resize', 'off');

    % Track if "OK" was pressed
    fig.UserData = struct('Confirmed', false);

    % 2. Create the grid 6 rows, 2 columns
    gl = uigridlayout(fig, [6, 2]);
    gl.RowHeight = {'1x', '1x', '1x', '1x', 45};
    gl.ColumnWidth = {'1x', '1x'};

    prompts = {'Dip:', 'Thikcness:', 'Strike:', 'Inclination:', 'Model Type:'};
    defaults = {'20', '30', '350', '10', 'DH'};
    
    modelTypeOptions = {'DH', 'HD'};

    % 3. Create Inputs
    editFields = cell(1, 5);

    for i = 1:5
        uilabel(gl, 'Text', prompts{i}, 'FontSize', 16);
        if i == 5
            editFields{i} = uidropdown(gl, 'Items', modelTypeOptions, 'Value', defaults{i}, 'FontSize', 16);
        else
            editFields{i} = uieditfield(gl, 'text', 'Value', defaults{i}, 'FontSize', 16);
        end
    end

    % 4. Add "OK" Button
    uibutton(gl, 'Text', 'OK', 'FontSize', 16, 'FontWeight', 'bold', ...
        'ButtonPushedFcn', @(btn,event) confirmAndResume(fig));

    % 5. Add "Cancel" Button (Column 2)
    uibutton(gl, 'Text', 'Cancel', 'FontSize', 16, ...
        'ButtonPushedFcn', @(btn,event) uiresume(fig)); % Just resume, Confirmed stays false

    % Wait for user interaction
    uiwait(fig);

    % 6. Logic to return data or empty cell
    if isvalid(fig) && fig.UserData.Confirmed
        answer = {editFields{1}.Value; editFields{2}.Value;
            editFields{3}.Value; editFields{4}.Value;
            editFields{5}.Value};
        delete(fig);
    else
        if isvalid(fig), delete(fig); end
        answer = {};
    end

end

% Internal helper function
function confirmAndResume(fig)
    fig.UserData.Confirmed = true;
    uiresume(fig);
end