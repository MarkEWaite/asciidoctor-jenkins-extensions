require 'asciidoctor'
require 'asciidoctor/extensions'

#
# Usage:
#
# For core Javadoc:
#
# jenkinsdoc:SCM[]
# jenkinsdoc:SCM[some label]
# jenkinsdoc:hudson.scm.SCM[]
# jenkinsdoc:hudson.scm.SCM[some label]
# jenkinsdoc:hudson.scm.SCM#anchor[]
# jenkinsdoc:hudson.scm.SCM#anchor[some label]
#
#
# For plugin Javadoc:
#
# jenkinsdoc:git:hudson.plugins.git.GitSCM[]
# jenkinsdoc:git:hudson.plugins.git.GitSCM[some label]
# jenkinsdoc:git:hudson.plugins.git.GitSCM#anchor[]
# jenkinsdoc:git:hudson.plugins.git.GitSCM#anchor[some label]

Asciidoctor::Extensions.register do
  inline_macro do
    named :jenkinsdoc
    name_positional_attributes 'label'

    process do |parent, target, attrs|

      if target.include? ":"
        parts = target.split(':', 2)
        plugin = parts.first
        target = parts.last
      end
      classname = label = title = target

      package_parts = Array.new
      simpleclass_parts = Array.new

      is_package = true

      classname.split('.').each do |part|
        if is_package && /[[:lower:]]/.match(part[0])
          package_parts.push(part)
        else
          is_package = false
          simpleclass_parts.push(part)
        end
      end

      package = package_parts.join('.')
      simpleclass = simpleclass_parts.join('.')

      if package.length > 0 || plugin
        classname = classname.gsub(/#.*/, '')
        classurl = package.gsub(/\./, '/') + '/' + simpleclass + ".html"

        classfrag = (target.include? "#") ? '#' + target.gsub(/.*#/, '') : ''

        if plugin
          label = (attrs.has_key? 'label') ? attrs['label'] : %(#{classname} in #{plugin})
          target = %(https://javadoc.jenkins.io/plugin/#{plugin}/#{classurl}#{classfrag})
        else
          label = (attrs.has_key? 'label') ? attrs['label'] : classname
          target = %(https://javadoc.jenkins.io/#{classurl}#{classfrag})
        end
      else
        label = (attrs.has_key? 'label') ? attrs['label'] : classname
        target = %(https://javadoc.jenkins.io/byShortName/#{classname})
      end

      title = %(Javadoc for #{classname})

      (create_anchor parent, label, type: :link, target: target, attributes: {'title' => title}).render
    end
  end
end

Asciidoctor::Extensions.register do
  inline_macro do
    named :staplerdoc
    name_positional_attributes 'label'

    process do |parent, target, attrs|

      classname = target

      package_parts = Array.new
      simpleclass_parts = Array.new

      is_package = true

      classname.split('.').each do |part|
        if is_package && /[[:lower:]]/.match(part[0])
          package_parts.push(part)
        else
          is_package = false
          simpleclass_parts.push(part)
        end
      end

      package = package_parts.join('.')
      simpleclass = simpleclass_parts.join('.')

      classname = target.gsub(/#.*/, '')
      classurl = package.gsub(/\./, '/') + '/' + simpleclass + ".html"

      classfrag = (target.include? "#") ? '#' + target.gsub(/.*#/, '') : ''
      label = (attrs.has_key? 'label') ? attrs['label'] : classname
      target = %(https://stapler.kohsuke.org/apidocs/#{classurl}#{classfrag})

      title = %(Javadoc for #{classname})

      (create_anchor parent, label, type: :link, target: target, attributes: {'title' => title}).render
    end
  end
end


Asciidoctor::Extensions.register do
  inline_macro do
    named :javadoc
    name_positional_attributes 'label'

    process do |parent, target, attrs|

      classname = target

      package_parts = Array.new
      simpleclass_parts = Array.new

      is_package = true

      classname.split('.').each do |part|
        if is_package && /[[:lower:]]/.match(part[0])
          package_parts.push(part)
        else
          is_package = false
          simpleclass_parts.push(part)
        end
      end

      package = package_parts.join('.')
      simpleclass = simpleclass_parts.join('.')

      classname = target.gsub(/#.*/, '')
      classurl = package.gsub(/\./, '/') + '/' + simpleclass + ".html"

      classfrag = (target.include? "#") ? '#' + target.gsub(/.*#/, '') : ''
      label = (attrs.has_key? 'label') ? attrs['label'] : classname
      target = %(https://docs.oracle.com/javase/8/docs/api/#{classurl}#{classfrag})

      title = %(Javadoc for #{classname})

      (create_anchor parent, label, type: :link, target: target, attributes: {'title' => title}).render
    end
  end
end
