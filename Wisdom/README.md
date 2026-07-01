# Mental - Web App

This is the web component of the Mental app (formerly known as Wisdom). It is a React application built with Vite that displays a constellation skill tree tracker.

## Development

```bash
npm install
npm run dev
```

## iOS Integration

This web application is bundled into the native iOS application located in `../ios/`.

To build the web application and sync it to the iOS project bundle, run the script from the root directory:

```bash
cd ..
./build_webapp.sh
```

This will run `npm run build` here and copy the contents of `dist/` to `../ios/Mental/webapp/`.
