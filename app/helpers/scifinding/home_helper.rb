module Scifinding
  module HomeHelper
    
      Tag_struct = Struct.new(:tag,:content,:options) do
                    #option: {:type,:for,:name,:value,:class, :placeholder} 
                     def initialize *p
                       super
                       refactor_options
                       self
                     end
                      
                     def refactor_options(opt={})
                       o = (self.options.is_a?(Hash) && self.options.stringify_keys ) || {} 
                       opt = (opt.is_a?(Hash) && opt.stringify_keys) if opt != {}
                       self.options = o.merge(opt)
                     end
                      
                   #  def html_format(opt={})
                   #    old_opt=self.options
                   #    refactor_options(opt)
                   #    html_tag = ActionView::Helpers::TagHelper::content_tag(*self)
                   #    self.options=old_opt
                   #    html_tag
                   #  end
                     
                     def with_html_options(opt={})
                       opt = (opt.is_a?(Hash) && opt.stringify_keys) || {}
                       opt = self.options.merge(opt)
                       [self.tag,self.content,opt]
                     end  

                     def hidden?
                       refactor_options
                       self.options['type'] == "hidden"
                     end
                     
                   end  
                  
      R_help = Struct.new(:path, :id, :tags) do 
                 def initialize *p  
                  super
                   self.tags = [] if !self.tags.is_a?(Array)
                 end
               end
      
    def resource_helper(xx)
      
      r_s='resource_'+xx.to_s
      r_sym=r_s.to_sym
      r= R_help.new
      r.path = r_s
      r.id   = r_s
     
      
      case xx.to_i
      when 51
         r.tags << Tag_struct.new(:label, 'Enter a patent number:', {'for': 'patent_num' })
         r.tags << Tag_struct.new(:input, nil, {name: 'patent_num', type: 'text', id:'patent_num', placeholder: 'US19928-41591' })
         r.tags << Tag_struct.new(:input, nil, {type: "submit", name: "commit", value:  'Retrieve patent info'})    
      when 52     
        r.tags << Tag_struct.new(:label, 'Enter DOI:', {'for': 'doi' })
        r.tags << Tag_struct.new(:input, nil, {name: 'doi', type: 'text', id:'doi', placeholder: '10.100.0.0/path/to/data' })
        r.tags << Tag_struct.new(:input, nil, {type: "submit", name: "commit", value:  'Retrieve doi info'})   
      when 53
        r.tags << Tag_struct.new(:label, 'Enter a CAS registry number:', {'for': 'cas_rn' })
        r.tags << Tag_struct.new(:input, nil, {name: 'cas_rn', type: 'text', id:'cas_rn', placeholder: '67-64-1' })
        r.tags << Tag_struct.new(:input, nil, {type: "submit", name: "commit", value:  'Retrieve molecule structure'})      
       when 61
         r.tags << Tag_struct.new(:label, 'Enter a patent number:', {'for': 'patent_num' })
         r.tags << Tag_struct.new(:input, nil, {name: 'patent_num', type: 'text', id:'patent_num', placeholder: 'US19928-41591' })
         r.tags << Tag_struct.new(:input, nil, {type: "submit", name: "commit", value:  'Retrieve patent link'})    
      when 62     
        r.tags << Tag_struct.new(:label, 'Enter DOI:', {'for': 'doi' })
        r.tags << Tag_struct.new(:input, nil, {name: 'doi', type: 'text', id:'doi', placeholder: '10.100.0.0/path/to/data' })
        r.tags << Tag_struct.new(:input, nil, {type: "submit", name: "commit", value:  'Retrieve doi link'})      
      when 63
        r.tags << Tag_struct.new(:label, 'Enter a CAS registry number:', {'for': 'cas_rn' })
        r.tags << Tag_struct.new(:input, nil, {name: 'cas_rn', type: 'text', id:'cas_rn', placeholder: '67-64-1' })
        r.tags << Tag_struct.new(:input, nil, {type: "submit", name: "commit", value:  'Retrieve molecule link'})   
      when 71	
        r.tags << Tag_struct.new(:label, 'Enter a SMILES:', {'for': 'smiles' })
        r.tags << Tag_struct.new(:textarea, nil, {name: 'smiles', type: 'text', id:'smiles' })
        r.tags << Tag_struct.new(:label, 'paste mdl data:', {'for': 'mdl' })
        r.tags << Tag_struct.new(:textarea, nil, {name: 'mdl', type: 'text', id:'mdl' })
        r.tags << Tag_struct.new(:label, 'Search type:', {'for': 'search_type' })
        r.tags << Tag_struct.new(:select, "<option>exact</option><option>substructure</option><option>similarity</option>".html_safe, {name: 'search_type',  id:'search_type' })
        r.tags << Tag_struct.new(:input, nil,{name: 'hit_count', type: 'hidden', id:'hit_count', value: 'true' })
        r.tags << Tag_struct.new(:input, nil, {type: "submit", name: "commit", value:  'Retrieve link to Answer'})
      when 72
        r.tags << Tag_struct.new(:label, 'Enter SMILES reagents:', {'for': 'smiles_r' })
        r.tags << Tag_struct.new(:textarea,  nil, {name: 'smiles_r', id:'smiles_r' , type:'text'})
        r.tags << Tag_struct.new(:label, 'Enter SMILES products:', {'for': 'smiles_p' })
        r.tags << Tag_struct.new(:textarea,  nil, {name: 'smiles_p', id:'smiles_p', type:'text' })
        r.tags << Tag_struct.new(:label, 'or import from a rxn file:', {'for': 'rxn_file' })
        r.tags << Tag_struct.new(:input, nil, {name: 'rxn_file[]', type: 'file', id:'rxn_file' })
        r.tags << Tag_struct.new(:label, 'Search type:', {'for': 'search_type' })
        r.tags << Tag_struct.new(:select, "<option>substructure</option><option>variable</option>".html_safe, {name: 'search_type',  id:'search_type'})
        r.tags << Tag_struct.new(:input, nil, {type: "submit", name: "commit", value:  'Retrieve link to Answer'})
      end
      r
    end
   
  end
end
