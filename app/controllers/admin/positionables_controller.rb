class Admin::PositionablesController < Admin::BaseController    
  
  class ::Admin::Positionable
     extend ActiveModel::Naming
     include ActiveModel::Conversion
     include ActiveModel::Validations
     extend ActiveModel::Translation
   
    attr_accessor :positionables
    def initialize(positionables)
      @positionables = positionables
    end

    def persisted?
      true
    end
  
    def id
      @positionables.klass.name
    end

  end
  
  
  def index
    @positionable_class = Positionable.get(params[:type])
    
    raise "NotFound" unless @positionable_class && @positionable_class.columns_hash["position"]
    
    @positionables = ::Admin::Positionable.new(@positionable_class.order("position"))
    @skip_filter = true
    @title = t('fullstack.admin.sort', :default => "Sort") + " - " + t("fullstack.admin.resources.#{@positionable_class.name.underscore.pluralize}", :default => @positionable_class.name.humanize)
  end
  
  def sort
    if subject.can_sort?(@positionable_class)
      @positionable_class = Positionable.get(params[:type])
      @positionable_class.update_positions(params[:positionables])
      redirect_to [:admin, params[:type]], :flash => { :notice => I18n.t("fullstack.admin.flash.success.generic") }
    end
  end  

  def fetch_object
    
  end

end