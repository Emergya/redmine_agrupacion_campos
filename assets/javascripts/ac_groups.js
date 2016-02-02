$(document).ready(function(){
	$('.add_field').on('click', function(){
		if (typeof i === 'undefined'){
			i = parseInt($(".add_field").data("count"));
		}else{
			i++;
		}

		$div_fieldset_open  = "<fieldset class='f_field fieldset_for_field_"+i+"'>"
		$label_field        = "<div class='d_field'><p class='p_field'><label for='ac_group_ac_fields_attributes_"+i+"_Campo personalizado: '>Campo personalizado: </label></p>"
		$select_field_open  = "<select id='ac_group_ac_fields_attributes_"+i+"_custom_field_id' name='ac_group[ac_fields_attributes]["+i+"][custom_field_id]'>"
		$select_options = "";

			$(".select_fields_hidden > option").each(function(){
				$select_value = $(this).val();
				$select_text = $(this).text();
				$select_options += "<option value='"+ $select_value +"'>"+ $select_text +"</option>";
			});

		$select_field_close = "</select></div>"
		$label_priority     = "<div class='d_field d_field_priority'><p class='p_field'><label for='ac_group_ac_fields_attributes_"+i+"_Prioridad: '>Prioridad: </label></p>"
		$input_priority     = "<input id='ac_group_ac_fields_attributes_"+i+"_priority' name='ac_group[ac_fields_attributes["+i+"][priority]' class='field_number_field' type='number'></div>"
		$link_delete        = "<div class='d_field d_field_delete'><a class='delete_field' data-count="+ i +" data-confirm='¿Desea eliminar este artículo?'><span class='icon icon-del'>Eliminar</span></a></div>"
		$div_fieldset_close = "</fieldset>"

		$fieldset_complete = $div_fieldset_open + $label_field + $select_field_open + $select_options + $select_field_close + $label_priority + $input_priority + $link_delete + $div_fieldset_close

		$(".btn_add_field").before($fieldset_complete);
	});
	
	$(document).on('click', '.delete_field', function(){
		i = $(".delete_field").data("count");
		$(".fieldset_for_field_"+i).remove();
	});
});