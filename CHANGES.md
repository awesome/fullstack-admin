# Fullstack Admin Change Log

## 0.2.14

Mainly a refactor of js/css to clean up the unessential.

- Added this file to keep track of changes
- JS/CSS moved from vendor to app/assets
- Dropped JS/CSS without direct dependencies in admin: gmap.js, angular.js, pickers.js 
- Deleted a lot of unused icons from iconic
- Now ckeditor is moved in a different gem: fullstack-ckeditor
- Dropped the simple_markup_input