# Fullstack Admin Roadmap

* Nested forms for Has Many associations 
  - Sorting
  - Autogenerate from has_many
  
* Multiple choice with chosen
  
* Use only twitter bootstrap (drop jquery-ui) (Next)
  - switch to bootstrap datepicker
  - find alternative to sortable
  
* Multiple scopes (Next)

* Image inputs

* Better rendering for boolean input

* Inference of input type from model
  eg.
    field :text, :text, :markup => true
    ->
    input :text, :as => :markup
    
  or
    has_attached :photo, :image => true
    ->
    input :photo, :as => :image
    