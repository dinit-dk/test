pageextension 55000 CustomerListExtCatFact extends "Customer List"
{
    actions
    {
        // We input which category we want our action to be inputted into.
        addfirst(General)
        {
            // We name and define our action in the code below.
            action("Cat Fact")
            {
                // Here we define different properties that we want our action to have.
                // We make sure the action is promoted and easy to find and give it a tooltip.
                ApplicationArea = all;
                ToolTip = 'An action to show cat facts';
                Promoted = true;
                ;
                PromotedIsBig = true;

                // We trigger a response when selecting the "Cat Fact" action in the menu
                trigger OnAction()
                // We Define our different variables.
                var
                    APICodeUnit: Codeunit "API Code Unit";
                begin
                    APICodeUnit.HttpMessage()
                end;

            }
        }
    }
}
