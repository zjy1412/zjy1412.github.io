# _plugins/typst_converter.rb

module Jekyll
    class TypstConverter < Converter
      safe true
      priority :low
  
      def matches(ext)
        ext =~ /^\.typ$/i
      end
  
      def output_ext(ext)
        ".html"
      end
  
      def convert(content)
        # 调用 Typst 命令行工具进行转换
        # 假设 typst 命令行工具已经安装并在 PATH 中
        result = `typst convert --to html #{content}`
        result
      end
    end
  end