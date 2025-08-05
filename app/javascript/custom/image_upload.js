import I18n from '../i18n'

const MINIMUM_LENGTH = 0

document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('#micropost_image');

    if (event.target === image_upload && image_upload.files.length > MINIMUM_LENGTH) {
      const size_in_megabytes = image_upload.files[0].size/1024/1024;

      if (size_in_megabytes > Settings.micropost.image_max_size.megabytes) {
        const message = I18n.t("microposts.image.too_large");
        alert(message);
        image_upload.value = "";
      }
    }
  })
})
