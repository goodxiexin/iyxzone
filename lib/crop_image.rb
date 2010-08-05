# extend resize image
module Technoweenie # :nodoc:
  module AttachmentFu # :nodoc:
    module Processors
      module RmagickProcessor
      protected :resize_image
        def resize_image(img, size)
          if (size.is_a?(String) && size =~ /^crop: (\\d*)x(\\d*)/i) || (size.is_a?(Array) && size.first.is_a?(String) && size.first =~ /^crop: (\\d*)x(\\d*)/i)
            img.crop_resized!($1.to_i, $2.to_i)
            self.temp_path = write_to_temp_file(img.to_blob)
          else
            super # Otherwise let attachment_fu handle it
          end
        end
      end
    end
  end
end

