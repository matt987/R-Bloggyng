#!/usr/bin/ruby
#requerimos la librería gtk
#depende de ruby-gnome2 - ruby-gnome-dev

#       Copyright 2011 Carlos Emanuel Mathiasen <matt987@mathiasen.com>
#                                Leandro Ariel Rodriguez <learod17@gmail.com>
#
#       This program is free software; you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation; either version 2 of the License.
#
#       This program is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with this program; if not, write to the Free Software
#       Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#       MA 02110-1301, USA.

require 'gtk2'
require 'principal'
require 'config'
#tiene que heredar de Gtk::Window
class Login < Gtk::Window
   #constructor de la clase
   def initialize()
        super
        @usuario     = Gtk::Entry.new
        @password  = Gtk::Entry.new
        @label_usuario = Gtk::Label.new "Alias"
        @label_password = Gtk::Label.new "Contraseña"
        @loguearse  = Gtk::Button.new "Loguearse"
        @table = Gtk::Table.new(6,3,true)
        self.set_windows
   end

   def set_windows
     set_title  "Loggin R-Bloggyn" #nombre de la ventana
     set_default_size -1, -1#tamaño de la ventana
     set_window_position Gtk::Window::POS_CENTER #posicion de la ventana
     self.in_table
     add @table
     show_all #muestra todo
     signal_connect ("destroy"){ Gtk.main_quit }#cuando se le da click al boton cerrar se cierra el programa
     self.signal_click
   end
   def in_table
     options = Gtk::EXPAND|Gtk::FILL
     @table.attach(@usuario,  1,  2,  1,  2, options, options, 0,    0)
     @table.attach(@password ,  1, 2, 3,  4, options, options, 0,    0)
     @table.attach(@loguearse,  1,  2,  5, 6, options, options, 0,    0)
     @table.attach(@label_usuario,  0,  1, 1,  2, options, options, 0,    0)
     @table.attach(@label_password,  0,  1,  3, 4, options, options, 0,    0)
   end

   def signal_click
     @loguearse.signal_connect("clicked")  do
       usuario = Usuario.login(@usuario.text,@password.text)
       unless usuario.blank?
         self.hide()
         Principal.new(usuario._id.to_s)
       else
         self.mensaje_dialogo('Alias no encontrado, están correctos los datos?')
       end
     end
   end

   #muestra un diálog según el valor pasado
   def mensaje_dialogo(string)
     md = Gtk::MessageDialog.new(self,
                                 Gtk::Dialog::DESTROY_WITH_PARENT, Gtk::MessageDialog::INFO,
                                 Gtk::MessageDialog::BUTTONS_CLOSE, string)
     md.run
     md.destroy
   end
end

Gtk.init
  Login.new
Gtk.main

