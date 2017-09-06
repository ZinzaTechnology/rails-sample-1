class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  process resize_to_fill: [150, 150]
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/"
  end

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [300, 300]
    process convert: 'jpg'
  end

  version :cover do
    process resize_to_fit: [240, 180]
    process convert: 'jpg'
  end

  def size_range
    0..3.megabytes
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "avatar.jpg" if original_filename
  end
end
