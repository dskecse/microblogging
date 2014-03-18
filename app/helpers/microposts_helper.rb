module MicropostsHelper
  def wrap(content)
    sanitize(raw(content.split.map { |s| wrap_long_string(s) }.join(' ')))
  end

  private

    def wrap_long_string(text, max = 30)
      zero_width_space = "&#8203;"
      (text.length < max) ? text :
                            text.scan(/.{1,#{max}}/).join(zero_width_space)
    end
end
