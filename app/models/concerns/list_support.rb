module ListSupport
  extend ActiveSupport::Concern

  MAX_STRING_LENGTH=32

  included do
    validates :extra_dataset_paths_list, length: { minimum: 0, maximum: 32 }
    validate :extra_dataset_path_elements_size
  end

  def extra_dataset_paths_list=(value)
    self.extra_dataset_paths = value.split(/,|\s/).map(&:strip).map(&:presence).compact
  end

  def extra_dataset_paths_list
    extra_dataset_paths.join(", ")
  end

  private

  def extra_dataset_path_elements_size
    extra_dataset_paths.each do |el|
      size = el.length
      errors.add(:extra_dataset_paths_list, "Parameter string size is too long (#{size}>#{MAX_STRING_LENGTH})") if size > MAX_STRING_LENGTH
    end
  end
end
