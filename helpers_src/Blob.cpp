#include "Blob.h"

void update_wrapper(Magick::Blob& blob, const std::string& data) {
    blob.update(data.c_str(),data.size());
}

std::string get_blob_data(const Magick::Blob& blob) {
    const char* data = static_cast<const char*>(blob.data());
    size_t length = blob.length();
    return std::string(data,data+length);
}
