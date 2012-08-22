# Fullstack Admin Roadmap

* Fix production issues

* Multiple choice input with chosen
  
* Image inputs + detect smaller image size for thumbnails

* Inference of input type from model
    has_attached :photo, :image => true
    ->
    input :photo, :as => :image

---

## Long run goals

* Use only twitter bootstrap (drop jquery-ui)
  - switch to bootstrap datepicker
  - find alternative to sortable
  
* Multiple scopes
* Tags input with chosen
* Optional tracking of author/updaters for every model

---

## Completed

* Better rendering for boolean input

* Nested forms for Has Many associations 
  - Sorting
  - Autogenerate from has_many
