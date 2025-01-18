# Copyright © 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Соглашение для использования ресурса по имени контроллера
#
module RansackSupport
  extend ActiveSupport::Concern
  included do
    helper_method :q, :index_form
    helper_method :model_class
  end

  def index
    respond_to do |format|
      format.html do
        render locals: {
          records:,
          paginated_records: paginate(records)
        }
      end
    end
  end

  private

  def model_class
    self.class.name.remove("Controller").singularize.gsub(/^.+::/, "").constantize
  end

  def index_form
    "index_form"
  end

  def q
    @q ||= build_q
  end

  def build_q
    qq = model_class.ransack(params[:q])
    qq.sorts = default_sort if qq.sorts.empty?
    qq
  end

  def default_sort
    "created_at desc"
  end

  def records
    includes = model_class.reflections.select do |_k, r|
      r.is_a?(ActiveRecord::Reflection::BelongsToReflection) && !r.options[:polymorphic]
    end.keys
    q.result.includes(includes)
  end
end
