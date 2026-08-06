function answer = mod_setup_dlg()
    fig = uifigure('Name', 'Model Setup', 'Position', [500 400 450 300], ...
                   'WindowStyle', 'modal', 'Resize', 'off');
    fig.UserData = struct('Confirmed', false);

    gl = uigridlayout(fig, [6, 2]);
    gl.RowHeight = {'1x', '1x', '1x', '1x', '1x', 45}; 
    gl.ColumnWidth = {'1.5x', '1x'};

    prompts = {'Splitting results file name:', 'Model type:', ...
               'Fast direction model space:', 'Delay time model space:', ...
               'Frequency content:'};
    defaults = {'okmok.csv', 'two', '-90:5:90', '0.4:0.2:3.0', '0.125'};

    % Options for the "Model type"
    modelTypeOptions = {'two', 'dip_2l', 'three', 'dip_3l'};

    editFields = cell(1, 5);
    for i = 1:5
        uilabel(gl, 'Text', prompts{i}, 'FontSize', 16);
        if i == 2
            editFields{i} = uidropdown(gl, ...
                'Items', modelTypeOptions, ...
                'Value', defaults{i}, ...
                'FontSize', 16);
        else
            editFields{i} = uieditfield(gl, 'text', ...
                'Value', defaults{i}, 'FontSize', 16);
        end
    end

    uibutton(gl, 'Text', 'OK', 'FontSize', 16, 'FontWeight', 'bold', ...
        'ButtonPushedFcn', @(btn,event) confirmAndResume(fig));
    uibutton(gl, 'Text', 'Cancel', 'FontSize', 16, ...
        'ButtonPushedFcn', @(btn,event) uiresume(fig));

    uiwait(fig);

    if isvalid(fig) && fig.UserData.Confirmed
        answer = {editFields{1}.Value; editFields{2}.Value; ...
                  editFields{3}.Value; editFields{4}.Value; editFields{5}.Value};
        delete(fig);
    else
        if isvalid(fig), delete(fig); end
        answer = {}; 
    end
end

function confirmAndResume(fig)
    fig.UserData.Confirmed = true;
    uiresume(fig);
end