class FileInput < FormtasticBootstrap::Inputs::FileInput
  def to_html
    bootstrap_wrapping do
      attachment = object.send(method)
      
      info_popup = "" 
      with_geom = attachment.styles.values.select do |decl|
        decl.geometry
      end
        
      if with_geom.any?
        infos = "<table class='table table-striped'>"
        with_geom.each do |s|
          infos << "<tr><th>#{s.name}</th><td>#{s.geometry}</td></tr>"
        end
        infos << "</table>"
        title = I18n.t('fullstack.admin.info', :default => "Info")
        content = template.send :h, infos
        info_popup << "&nbsp; <i class='icon icon-info-sign' title='#{title}' data-content='#{content}' data-toggle='popover'></i>"
      end
      
      
      if !attachment.exists?
        <<-eos
          <span class="file-input-attachment-filename">
            <i class="icon icon-file"></i> (#{I18n.t('fullstack.admin.no_file_uploaded', :default => "No file uploaded")})
          </span> 
          <span>#{info_popup}</span>
        
          <a class="btn btn-small file-input-choose-file-button" href="javascript:void(0)">
            <i class="icon icon-upload"></i>
            #{I18n.t('fullstack.admin.choose_a_file', :default => "Choose a file")}
          </a>
        eos
      
      else
        preview_menu = ""
        
        preview_menu << template.content_tag(:li, template.link_to(I18n.t('fullstack.admin.original', :default => "Original"), 
        attachment.url(:original),
        :target => "_blank"
        
        ))
        
        preview_menu << template.content_tag(:li, "", :class => :divider) if !attachment.styles.empty?
        
        attachment.styles.map do |name, decl|
          preview_menu << template.content_tag(:li,  template.link_to(name.to_s.humanize, attachment.url(name), :target => "_blank"))
        end

        <<-eos
        
        <span  class="file-input-attachment-filename"><i class="icon icon-file"></i> #{template.send(:html_escape, attachment.url.split("/").last.split("?").first)} </span> 
        <span>#{info_popup}</span>
        
        <a class="btn btn-small file-input-choose-file-button" href="javascript:void(0)">
          <i class="icon icon-upload"></i>
          #{I18n.t('fullstack.admin.change', :default => "Change")}
        </a>
        <span class="dropdown">
          <a class="btn dropdown-toggle btn-small" data-toggle="dropdown" href="#">
            <i class="icon icon-eye-open"></i>
            #{I18n.t('fullstack.admin.preview', :default => "Preview")}
            <span class="caret"></span>
          </a>
          <ul class="dropdown-menu">
            #{preview_menu}
          </ul>
        
        </span>
        
        #{template.button(
          I18n.t('fullstack.admin.delete', :default => "Delete"),
          "javascript:void(0)",
          :type => :danger, :class => "file-input-delete-attachment-button btn-small", :"data-toggle" => :button
          )}
        
        eos
      
      end.html_safe << builder.file_field(method, :style => "display:none;") << (builder.check_box("#{method}_delete", :class => "file-input-delete-attachment-checkbox", :style => "display:none;") if attachment.exists?)
    end
  end
end


        
