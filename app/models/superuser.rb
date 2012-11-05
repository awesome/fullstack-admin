class Superuser < ActiveRecord::Base
  authenticates_with_sorcery!
  def has_role?(r)
    true
  end
end
