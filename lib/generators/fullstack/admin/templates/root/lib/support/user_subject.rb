class UserSubject < Checkin::Subject

      role :guest, :alias => :anonymous do
          !subject_model
      end

      role :logged_in, :alias => [:connected] do
          !!subject_model
      end

      role :owner, :require => [:logged_in], :method => :own do |object|
          object && ( object.respond_to?(:author) && ( subject_model == object.author ) ) ||  ( object.respond_to?(:owner) && ( subject_model == object.owner ) )
      end
      
      role :administrator, :require => :logged_in, :alias => :admin do
          subject_model.has_role?(:administrator)
      end

      #
      # Permissions
      #

      # Admin

      scope :admin do
        permissions do
          allow :administrators
          deny
        end
      end

end

