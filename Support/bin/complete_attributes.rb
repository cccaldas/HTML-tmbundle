#!/usr/bin/env ruby -wKU

require ENV['TM_SUPPORT_PATH'] + '/lib/osx/plist'
require ENV['TM_SUPPORT_PATH'] + '/lib/ui'

def create_choice(display, insert)  
  choice = "({display = '" + display + "'; insert = '" + insert + "';},)"
  return OSX::PropertyList.load(choice)
end

def search_css(word)
  project_path = ENV["TM_PROJECT_DIRECTORY"]
  result = %x( grep -Rni --include=\*.css --exclude=.svn --exclude=.git '#{word}' "#{project_path}" )
  return result
end

def get_css_classes() #(\.-?[_a-zA-Z]+[_a-zA-Z0-9-]*\s*\-?)
  #print file_name
  
  #classes = search_css("\.[_a-zA-Z][_a-zA-Z0-9-]")
  classes = search_css("\.[a-k]")
  css_classes = []
  classes.each {
    |cl|
    #print cl
    if cl.index("#") == nil && cl.index(":.") != nil
      cl = cl.split(":.")[1]
      cl = cl.sub("{", "")
      cl = cl.sub("\n", "")
      cl = cl.sub("\t", "")
      cl = cl.sub(" ", "")
      css_classes.push(cl)
    end
      
  }
  
  return css_classes
end

begin
  choices = []
  
  tm_current_word       = ENV["TM_CURRENT_WORD"]
  tm_filepath           = ENV["TM_FILEPATH"]
  tm_current_line       = ENV["TM_CURRENT_LINE"]
  tm_current_column     = ENV["TM_CURRENT_COLUMN"]
  tm_project_directory  = ENV["TM_PROJECT_DIRECTORY"]
  tm_line_index         = ENV["TM_LINE_INDEX"]
  
  #class
  if(tm_current_word.index("class=") != nil)
    #classes = get_css_classes(tm_project_directory + "/Test/test-1.css")
    classes = get_css_classes()
    classes.each {
      |cl|
      choices += create_choice(cl, "")
    }
    #print classes
  end  
  
  #id
  if(tm_current_word.index("id=") != nil)
    
  end
  
  #choices += create_choice("element-1", "")
  #choices += create_choice("element-2", "")
  
  print "debug, tm_current_word: " + tm_current_word + ", tm_current_line: " + tm_current_line + ", column: " + tm_line_index
  
  tm_current_word = ""
  
  TextMate::UI.complete(choices, :initial_filter => tm_current_word, :extra_chars => '_')
end
