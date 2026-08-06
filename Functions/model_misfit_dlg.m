function choice = model_misfit_dlg(questionText)
    % 1. Create the figure
    fig = uifigure('Name', 'Confirmation', 'Position', [550 450 400 180], ...
                   'WindowStyle', 'modal', 'Resize', 'off');
    
    % Default choice is false (No)
    fig.UserData = false;

    % 2. Create the grid: 2 rows (Question, Buttons)
    gl = uigridlayout(fig, [2, 2]);
    gl.RowHeight = {'1x', 50};
    gl.ColumnWidth = {'1x', '1x'};

    % 3. Add the Question Label (Spans both columns)
    lbl = uilabel(gl, 'Text', questionText, 'FontSize', 16, ...
                 'HorizontalAlignment', 'center', 'WordWrap', 'on');
    lbl.Layout.Row = 1;
    lbl.Layout.Column = [1 2];

    % 4. Add "Yes" Button
    uibutton(gl, 'Text', 'Weighted', 'FontSize', 16, 'FontWeight', 'bold', ...
        'ButtonPushedFcn', @(btn,event) confirmChoice(fig));

    % 5. Add "No" Button
    uibutton(gl, 'Text', 'Unweighted', 'FontSize', 16, ...
        'ButtonPushedFcn', @(btn,event) uiresume(fig));



    % Wait for user interaction
    uiwait(fig);
    
    % 6. Return result and clean up
    if isvalid(fig)
        choice = fig.UserData;
        delete(fig);
    else
        choice = false; % Closed window counts as 'No'
    end
end

function confirmChoice(fig)
    fig.UserData = true;
    uiresume(fig);
end