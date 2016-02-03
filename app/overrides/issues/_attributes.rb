Deface::Override.new :virtual_path  => 'issues/_attributes',
                     :name          => 'add_custom_fields_fieldsets',
                     :original		=> '6f51d1720dcba22efc11238cbe8522ba43570644',
                     :replace    	=> "erb[loud]:contains(\"render :partial => 'issues/form_custom_fields'\")",
                     :partial       => 'issues/partials/fields_fieldset'

