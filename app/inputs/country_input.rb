class CountryInput < FormtasticBootstrap::Inputs::SelectInput

   def to_html
     builder.input(method, :as => :select, :collection => Iso3166.codes.map {|code| Iso3166.localize(code)})
   end
      



end