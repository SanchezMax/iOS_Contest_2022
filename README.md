#  iOS Contest 2022

<p>
  A media editing app in Swift similar to the native iOS drawing tool. Based on <a href="https://electron.atom.io/">Electron</a>, <a href="https://facebook.github.io/react/">React</a>, <a href="https://github.com/reactjs/react-router">React Router</a>, <a href="https://webpack.js.org/">Webpack</a> and <a href="https://www.npmjs.com/package/react-refresh">React Fast Refresh</a>.
</p>

<p>
Used frameword:
-[SwiftUI](https://developer.apple.com/xcode/swiftui)
-[UIKit](https://developer.apple.com/documentation/uikit)
-[PencilKit](https://developer.apple.com/documentation/pencilkit)
-[PhotosUI](https://developer.apple.com/documentation/photokit)
</p>

<br>

<div align="center">

[![Build Status][github-actions-status]][github-actions-url]

</div>

## Install

To build this project, you have to use MacOS and have Xcode installed.
Then, open the project by double-clicking "IOSContest2022.xcodeproj".
Make sure you've signed it with your Team's signification (iOSContest2022 -> Signing & )
First, clone the repo via git and install dependencies:

```bash
git clone --depth 1 --branch main https://github.com/irzgit/irz-tek-recovery.git your-project-name
cd your-project-name
yarn
```

## Starting Development

Start the app in the `dev` environment:

```bash
yarn start
```

## Packaging for Production

To package apps for the local platform:

```bash
yarn build
yarn package
```

If target platform is Windows, you need to install [Wine](https://www.winehq.org/) first:

```bash
sudo apt install wine
yarn build
yarn package --win
```

## Maintainers

- [Max Zykin](https://github.com/SanchezMax)


[github-actions-status]: https://github.com/SanchezMax/iOS_Contest_2022/workflows/Test/badge.svg
[github-actions-url]: https://github.com/SanchezMax/iOS_Contest_2022/actions
