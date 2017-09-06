# frozen_string_literal: true

module BaseUtil
  def model
    controller_name.classify.safe_constantize
  end

  def model_name
    controller_name.singularize
  end

  def model_name_symbol
    model_name.intern
  end

  def build_instance
    _instance = model.new
    instance_variable_set "@#{model_name}", _instance
  end

  def set_instance
    _instance = model.find_by id: params[:id]
    return redirect_to root_url if _instance.blank?

    instance_variable_set "@#{model_name}", _instance
  end

  def instance
    instance_variable_get "@#{model_name}"
  end

  def set_params
    instance.assign_attributes model_params
  end

  def model_params
    return unless params[model_name_symbol]

    params.require(model_name_symbol)
          .permit model::DEFAULT_UPDATABLE_ATTRIBUTES
  end
end
