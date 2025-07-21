This is a Nix flake to package pre-release versions of Workrave that
play nicer with Wayland compositors, especially those that support the
version of the [`ext-idle-notify`
protocol](https://wayland.app/protocols/ext-idle-notify-v1) that
supports the `get_input_idle_notification` request, which allows
Workrave to not be "confused" by idle notifiers meant to keep the
screen from blanking even when there is no user input.

Since Workrave is under
[GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), the patch
here is also under GPL-3.0. The Nix code, though, is simply under the
[MIT license](https://opensource.org/license/mit).
