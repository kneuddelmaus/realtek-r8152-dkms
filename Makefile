# Copyright (C) 2022 Deokgyu Yang <secugyu@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

all: clean modules install install_rules

modules:
	$(MAKE) -C src/ modules

clean:
	$(MAKE) -C src/ clean

install: modules
	$(MAKE) -C src/ install

install_rules:
	$(MAKE) -C src/ install_rules
