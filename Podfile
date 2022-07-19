# Uncomment the next line to define a global platform for your project

platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

def rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxGesture'
end

def generation
  pod 'R.swift'
end

def parse
  pod 'ObjectMapper'
end

def apiTools
  pod 'Action'
end


target 'Carol' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  rx
  generation
  parse
  apiTools
end

target 'CarolTests' do
  inherit! :search_paths
  # Pods for testing
end

target 'CarolUITests' do
  # Pods for testing
end
