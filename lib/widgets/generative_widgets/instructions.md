## AI Coding Agent Instructions

Generate a catalog of UI components and widgets for a Flutter application. 
It must be able to take exclusively streams of strings as input or parameters and display them using accumulating stream builders (we have a widget for that), or take in a full string and then turn that string into a stream and display that using the same logic, avoiding code duplication for handling the two cases.

The catalog of components will be categorized into the following:

- Essential Components: These are components that are used to create the UI. They are used to create the UI.

    - Button: Allows users to press buttons
        - LabelText: text (default to "Button") 
        - IconText: text (default to empty string, represents icon name/identifier)
        - StyleTag: primary, normal (default), danger
        - **CODE GENERATION NOTICE: The style tag will determine if its a Filled, Elevated, Filled but red, or Disabled button. Create seperate widgets for this, named GenerativeFilledButton, GenerativeElevatedButton, and GeneratedDangerButton**

    - MarkdownText: Shows formatted text to users
        - DisplayText: text (default to "Text")
        - **CODE GENERATION NOTICE: Name this GenerativeText**

    - TextField: Allows users to input text
        - LabelText: text (default to "Textfield")
        - HintText: text (default to "Type here")
        - **CODE GENERATION NOTICE: Name this GenerativeTextField**


- Layout Components: These are components that are used to layout other components. They are used to create the structure of the UI.
    
    - Card: A card in the UI containing a component
        - ItemComponent: object for a component (default this to a sized box 32x32 in size)
        - **CODE GENERATION NOTICE: Name this GenerativeCard**

    - VerticalStack: Layouts its items vertically
        - ItemComponents: array of component objects (default to empty)
        - GapNumber: Decimal Number (default to 8)
        - **CODE GENERATION NOTICE: Name this GenerativeColumn**

    - HorizontalStack: Layouts its items horizontally
        - ItemComponents: array of component objects (default to empty)
        - GapNumber: Decimal Number (default to 8)
        - **CODE GENERATION NOTICE: Name this GenerativeRow**

**NOTICE ABOUT DEFAULTS: Only use the default if their stream completed without a value, or if the full json does not have the property provided**

**ANOTHER NOTICE: "LAYOUT COMPONENTS" AND "ESSENTIAL COMPONENTS" ARE NOT WIDGETS, THEY'RE CATEGORIES. THE COMPONENTS ARE: BUTTON WITH 3 PARAMETERS AND 3 TYPES, MARKDOWNTEXT WITH 1 PARAMTER, TEXTFIELD WITH TWO PARAMETERS, CARD WITH ONE PARAMETER, VERTICALSTACK WITH TWO PARAMETERS, AND HORIZONTAL STACK WITH TWO PARAMETERS**

Each component will have a `static String get PROMPT => '...'` for type definitions of what the component requires, what it is for, and an example. Display them 


