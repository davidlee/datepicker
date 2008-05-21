#!/usr/bin/env ruby

# Rails Datepicker 
# http://projects.exactlyoneturtle.com/datepicker
# svn://exactlyoneturtle.com/svn/datepicker
#
# Author: David Lee, 2006
#
# License: MIT
# see the MIT license at ....
#
# TODO: finish header

require 'fileutils'
require 'find'

include FileUtils #::Verbose

class PluginInstaller
  
  RAILS_DIR  = File.expand_path( './../../../' )
  SOURCE_DIR = File.expand_path( './source_files'+ '/' )

  require './installer/welcome'
  require './installer/goodbye'
  
  ## INITIALIZER ##

  def initialize
    # Check to see if any options are passed 
    puts help_message and return unless ARGV.empty?

    # check source & destination directories exist
    quit( 'Cant find rails root directory' ) \
      unless FileTest.directory?( RAILS_DIR )
    quit( 'Cant find installer source directory -- please run installer.rb from the plugin directory' ) \
      unless FileTest.directory?( SOURCE_DIR )

    # Print opening message
    puts WELCOME

    # generate list of files to be copied
    prepare_file_list( )
    # make sure this is ok
    confirm_proceed( )

    puts "Ok. Beginning copy operations ...\n\n"
    # actually copy them
    copy_files( )
   
    # list the files for addition to subversion
    list_for_svn_add( )

    # Display exit message and documentation
    puts GOODBYE
  end

  ## SUPPORT FUNCTIONS ##

  def prepare_file_list
    puts "\nThe following files will be added to your application directory: \n\n"
    @files = []
    chdir( RAILS_DIR ) do
      Find.find( SOURCE_DIR ) do |path|
        fname = path.sub( SOURCE_DIR, '' )
        # dont copy over or create any directories which already exist
        next if FileTest.directory?(RAILS_DIR + fname)
        puts fname
        @files << fname
      end
    end
    puts
  end

  def confirm_proceed
    begin 
      puts "\nDon't worry too much if any of these files already exist in the destination directory."
      puts "You'll be asked what to do about them in the next step.\n\n"
      puts "Continue ( Y/n )? "
      answer = gets.strip.downcase[0..1] rescue nil
      quit( "User terminated the installer prior to any file operations" ) if answer == 'n'
    end while ! ['','y','n'].include?( answer )
  end

  def quit( message )
    puts "\nExiting installation: \n#{message}"
    exit
  end

  def copy_files
    @copied_files = []
    action_for_existing = ''
    @files.each do |fname|
      if FileTest.exists?(RAILS_DIR + fname) 
        if !%w[a l ].include?( action_for_existing )
          puts "The following file exists:" 
          puts "  #{fname}\n\n"
          puts "What do you want to do?"
          puts "The default is to leave the current file alone and ask again for the next file."
          puts "You can choose to: "
          begin
            puts "  Overwrite this file only (o/y)"
            puts "  overwrite All files (a)"
            puts "  Ignore this file only (i/n)"
            puts "  Leave all existing files alone (l)"
            puts "  Quit (q)\n\n"
            puts "Please choose (o/a/I/l/q)?"
            action_for_existing = gets.strip.downcase[0..1] rescue nil
            action_for_existing = 'i' if action_for_existing == ''
          end while ! %w[o a i l q y n].include?( action_for_existing )
        end
        # now we know what to do about the existing file ...
        a = action_for_existing
        if %w[a y o].include?( a )
          puts "Overwriting #{fname}"
        elsif %w[l n i].include?( a )
          puts "Ignoring #{fname}"
          next # next in @files.each loop, so duplicate file is skipped
        elsif a == 'q'
          quit( 'User terminated the installer during file copy process' )
        end
        # reset user action unless it was intended to answer subsequent queries 
        action_for_existing = '' unless %w[a l].include?( a )
      end
      # if next has not been called by now, proceed with file copy
      puts "copying the file #{fname}"
      # TODO: insrt copy command ... 
      @copied_files << fname
    end
  end

  def list_for_svn_add
    puts "\nIf you wish to add the files to subversion, now's the time to execute\n\n"
    @copied_files.each{|file| puts "  svn add #{file}" } 
    puts
  end

end

PluginInstaller.new
