# phase-i-project

Phase I Project is a wireframe design of JubiAudio Phase I as described in [this](https://github.com/lesseradmin/PhaseIWireframe/blob/master/blueprint/Assignment.pdf) spec document.


## Requirements

- iOS 10.0+
- XCode 8.0+
- Swift 3.0+


## Instalation


### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
> CocoaPods 1.0.0+ is required to build this project.

Once, cocoapods has been installed, run the following command:

```bash
$ pod install
```

This will install all of the required dependencies to edit, run, and test this project. These can all be done by opening `~/PhaseIWireframe.xcuserstate` using XCode.

## Creation

I started building this project by planning out the key components that it would include. Initially, after looking at the provided wireframe I decided to go with a simple design for logging in / creating an account. I also added in another option to test out the demo tools without needing to sign in. When creating the demo tools, I started out by creating a color palette. I initially browsed through [coolors.co](https://coolors.co) until I found a color that I liked for the background. This color ended up being Gunmetal (`UIColor.BACKGROUND`).

Once I had this color, I generated different shades of this color to find a set of slate colors for the application. These slate colors include Isabelline (`UIColor.WHITE`), Silver Chalice (`UIColor.CREME`), Outter Space (`UIColor.CHARCOAL`), Gunmetal (`UIColor.BACKGROUND`), and Raisin Black (`UIColor.BLACK`). Once these slate colors were found, I once again browsed through [coolors.co](https://coolors.co) until I found good highlight colors that I could use for `GeneralUIButton`, `GeneralUILabel`, `GeneralUITextField`, `GeneralUIViewController`, and `UINavigationBar`.

Here is the final color palette:

![final_color_palette](https://raw.githubusercontent.com/lesseradmin/PhaseIWireframe/master/Assets/Color%20Palettes/Color%20Palette%20Final/ColorPalette.png?token=AGysF6-dSYDG6mAi9au_kVZlNMj2ZZxqks5ZNMCrwA%3D%3D)

Once the color palette was created I started to design custom components for `GeneralUIButton`, `GeneralUIViewController`, `GeneralUITextField`, `CustomUITextField`, `GeneralUITableView`, `GeneralUITableViewCell`, and `UINavigationBar`.

Here are the Custom UI Components:


![custom_ui_components](https://raw.githubusercontent.com/lesseradmin/PhaseIWireframe/master/Assets/UIComponents/UIComponents%403x.png?token=AGysFxBQChLUDXmeGu6Ocbs3olnT0pIrks5ZNMyawA%3D%3D)

## Support

Please [open an issue] (https://github.com/lesseradmin/PhaseIWireframe/issues/new) for support.


## Contributing 

Please contribute using [Github Flow](https://guides.github.com/introduction/flow/). Create a branch, add commits, and [open a pull request](https://github.com/lesseradmin/PhaseIWireframe/compare/).


## License

This project is licensed under the MIT License. For a full copy of this license take a look at the LICENSE file.

