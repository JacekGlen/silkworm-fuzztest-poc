#    Copyright 2023 The Silkworm Authors

#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at

#        http://www.apache.org/licenses/LICENSE-2.0

#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

from conan import ConanFile

class SilkwormRecipe(ConanFile):
    settings = 'os', 'compiler', 'build_type', 'arch'
    generators = 'cmake_find_package'

    def requirements(self):
        self.requires('nlohmann_json/3.11.2')
        self.requires('boost/1.81.0')

    # def configure(self):
    #     self.options['asio-grpc'].local_allocator = 'boost_container'

    #     # Currently Conan Center has Windows binaries built only with msvc 16 only and mimalloc built only with option override=False
    #     # In order to build mimalloc with override=True we need to switch to msvc 17 compiler but this would trigger a full rebuild from
    #     # sources of all dependencies wasting a lot of time, so we prefer to turn off mimalloc override
    #     # The same applies also for boost with option asio_no_deprecated
    #     if self.settings.os != 'Windows':
    #         self.options['boost'].asio_no_deprecated = True
    #         self.options['mimalloc'].override = True
