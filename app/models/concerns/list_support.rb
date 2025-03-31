module ListSupport
  def extra_dataset_paths_list=(value)
    self.extra_dataset_paths = value.split(/,|\s/).map(&:strip).map(&:presence).compact
  end

  def extra_dataset_paths_list
    extra_dataset_paths.join(", ")
  end
end
