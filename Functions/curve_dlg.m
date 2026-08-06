function top = curve_dlg()

    % 1. Create the figure
    fig = uifigure('Name', 'Model Curves', 'Position', [500 300 400 200], ...
        'WindowStyle', 'modal', 'Resize', 'off');

    % Track if "OK" was pressed
    fig.UserData = struct('Confirmed', false);

    % 2. Create the grid (2 row, 2 columns)
    gl = uigridlayout(fig, [2, 2]);
    gl.RowHeight = {'0.5x', '0.5x'};
    gl.ColumnWidth = {'1x', '1x'};

    prompts = {'Models to plot:'};
    defaults = {'20'};

    % 3. Create Inputs
    editFields = cell(1, 2);

    for i = 1:1
        uilabel(gl, 'Text', prompts{i}, 'FontSize', 16);
        editFields{i} = uieditfield(gl, 'text', 'Value', defaults{i}, 'FontSize', 16);
    end
    
    % 4. Add "OK" Button
    uibutton(gl, 'Text', 'OK', 'FontSize', 16, 'FontWeight', 'bold', ...
        'ButtonPushedFcn', @(btn,event) confirmAndResume(fig));

    % Wait for user interaction
    uiwait(fig);

    % 6. Logic to return data or empty cell
    if isvalid(fig) && fig.UserData.Confirmed
        top = {editFields{1}.Value};
        delete(fig);
    else
        if isvalid(fig), delete(fig); end
        top = {};
    end

end

% Internal helper function
function confirmAndResume(fig)
    fig.UserData.Confirmed = true;
    uiresume(fig);
end