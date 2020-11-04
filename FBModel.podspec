Pod::Spec.new do |spec|
  spec.name         = "FBModel"
  spec.version      = "0.0.10"
  spec.summary      = "A simple utility for the model layer in MVC and MVVM patterns"

  spec.description  = "Just a simple utility for the model layer based on Codable, to translate models to json and from json with ease"

  spec.homepage     = "https://github.com/Felip38rito/FBModel"
  spec.license      = "MIT"
  spec.author             = { "Felipe Correia Brito" => "felipe.correia.wd@gmail.com" }
  spec.platform     = :ios, "12.0"
  spec.source       = { :git => "https://github.com/Felip38rito/FBModel.git", :tag => "#{spec.version}" }
  spec.source_files  = "FBModel", "FBModel/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"

end
