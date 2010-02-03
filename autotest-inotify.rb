# http://blog.tryphon.org/alban/media/2007-10-26-autotest-inotify.rb

#
# Requires inotify
# see http://www.bouh.org/inotify/
#
# for example, install
# http://www.bouh.org/inotify/INotify-0.3.0.rb into /usr/local/lib/site_ruby/1.8
#

require 'INotify'
require 'find'

def ignore_file_changes?(filename)
  exclusions = [ /(swp|~|rej|orig)$/, /\/\.?#/, /^\./ ]
  exclusions.any? { |exclusion| filename =~ exclusion }
end

def wait_for_inotify_event
#  puts "wait for inotify event ..."
  inotify = INotify::INotify.new
  inotify_mask = INotify::Mask.new(INotify::IN_MODIFY.value | INotify::IN_DELETE.value | INotify::IN_CREATE.value | INotify::IN_MOVED_TO.value, 'filechange')

  %w(app test lib).each do |directory|
    Find.find(directory) do |file|
      if %(.svn CVS RCS).include?File.basename(file) or !File.directory? file
        Find.prune
      else
        inotify.watch_dir(file, inotify_mask)
      end
    end
  end

  events = []
  while (events.empty?)
    events.push(*inotify.next_events)
    events = events.delete_if { |event| ignore_file_changes?(event.filename) }
  end

  inotify.close
end

class Autotest
  def wait_for_changes
    hook :waiting
    begin
      wait_for_inotify_event
    end until find_files_to_test
  end
end

