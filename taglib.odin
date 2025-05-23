package taglib

when ODIN_OS == .Windows {
	@(extra_linker_flags="/NODEFAULTLIB:" + ("libcmt"))
	foreign import lib {
        "windows/tag.lib",
        "windows/tag_c.lib",
        "windows/zlib.lib",
	}
    // Linux and Mac builds of taglib and import libs here
}

TagLib_File            :: struct { dummy: int }
TagLib_Tag             :: struct { dummy: int }
TagLib_AudioProperties :: struct { dummy: int }
TagLib_IOStream        :: struct { dummy: int }

TagLib_File_Type :: enum {
    MPEG,
    OggVorbis,
    FLAC,
    MPC,
    OggFlac,
    WavPack,
    Speex,
    TrueAudio,
    MP4,
    ASF,
    AIFF,
    WAV,
    APE,
    IT,
    Mod,
    S3M,
    XM,
    Opus,
    DSF,
    DSDIFF,
    SHORTEN,
}

TagLib_ID3v2_Encoding :: enum {
    Latin1,
    UTF16,
    UTF16BE,
    UTF8,
}

TagLib_Variant_Type :: enum {
    Void,
    Bool,
    Int,
    UInt,
    LongLong,
    ULongLong,
    Double,
    String,
    StringList,
    ByteVector,
}

TagLib_Variant :: struct {
    type: TagLib_Variant_Type,
    size: u32,
    value: struct #raw_union {
        stringValue:        cstring,
        byteVectorValue:    cstring,
        stringListValue:    ^cstring,
        boolValue:          int, // using int for BOOL
        intValue:           int,
        uIntValue:          u32,
        longLongValue:      i64,
        uLongLongValue:     u64,
        doubleValue:        f64,
    },
}

TagLib_Complex_Property_Attribute :: struct {
    key:   cstring,
    value: TagLib_Variant,
}

TagLib_Complex_Property_Picture_Data :: struct {
    mimeType:     cstring,
    description:  cstring,
    pictureType:  cstring,
    data:         cstring,
    size:         u32,
}

@(default_calling_convention="c", link_prefix="taglib_")
foreign lib {
    // Global functions
    set_strings_unicode :: proc(unicode: int) ---
    set_string_management_enabled :: proc(management: int) ---
    free :: proc(ptr: rawptr) ---

    // Stream API
    memory_iostream_new :: proc(data: cstring, size: u32) -> TagLib_IOStream ---
    iostream_free :: proc(stream: TagLib_IOStream) ---

    // File API
    file_new :: proc(filename: cstring) -> TagLib_File ---
    file_new_type :: proc(filename: cstring, type: TagLib_File_Type) -> TagLib_File ---
    file_new_iostream :: proc(stream: TagLib_IOStream) -> TagLib_File ---
    file_free :: proc(file: TagLib_File) ---
    file_is_valid :: proc(file: TagLib_File) -> int ---
    file_tag :: proc(file: TagLib_File) -> TagLib_Tag ---
    file_audioproperties :: proc(file: TagLib_File) -> TagLib_AudioProperties ---
    file_save :: proc(file: TagLib_File) -> int ---

    // Tag API
    tag_title :: proc(tag: TagLib_Tag) -> cstring ---
    tag_artist :: proc(tag: TagLib_Tag) -> cstring ---
    tag_album :: proc(tag: TagLib_Tag) -> cstring ---
    tag_comment :: proc(tag: TagLib_Tag) -> cstring ---
    tag_genre :: proc(tag: TagLib_Tag) -> cstring ---
    tag_year :: proc(tag: TagLib_Tag) -> u32 ---
    tag_track :: proc(tag: TagLib_Tag) -> u32 ---
    tag_set_title :: proc(tag: TagLib_Tag, title: cstring) ---
    tag_set_artist :: proc(tag: TagLib_Tag, artist: cstring) ---
    tag_set_album :: proc(tag: TagLib_Tag, album: cstring) ---
    tag_set_comment :: proc(tag: TagLib_Tag, comment: cstring) ---
    tag_set_genre :: proc(tag: TagLib_Tag, genre: cstring) ---
    tag_set_year :: proc(tag: TagLib_Tag, year: u32) ---
    tag_set_track :: proc(tag: TagLib_Tag, track: u32) ---
    tag_free_strings :: proc() ---

    // Audio Properties API
    audioproperties_length :: proc(ap: TagLib_AudioProperties) -> int ---
    audioproperties_bitrate :: proc(ap: TagLib_AudioProperties) -> int ---
    audioproperties_samplerate :: proc(ap: TagLib_AudioProperties) -> int ---
    audioproperties_channels :: proc(ap: TagLib_AudioProperties) -> int ---

    // ID3v2
    id3v2_set_default_text_encoding :: proc(enc: TagLib_ID3v2_Encoding) ---

    // Property API
    property_set :: proc(file: TagLib_File, prop, value: cstring) ---
    property_set_append :: proc(file: TagLib_File, prop, value: cstring) ---
    property_keys :: proc(file: TagLib_File) -> ^^cstring ---
    property_get :: proc(file: TagLib_File, prop: cstring) -> ^^cstring ---
    property_free :: proc(props: ^^cstring) ---

    // Complex Property API
    complex_property_set :: proc(file: TagLib_File, key: cstring, value: ^^TagLib_Complex_Property_Attribute) -> int ---
    complex_property_set_append :: proc(file: TagLib_File, key: cstring, value: ^^TagLib_Complex_Property_Attribute) -> int ---
    complex_property_keys :: proc(file: TagLib_File) -> ^^cstring ---
    complex_property_get :: proc(file: TagLib_File, key: cstring) -> ^^^TagLib_Complex_Property_Attribute ---
    picture_from_complex_property :: proc(props: ^^^TagLib_Complex_Property_Attribute, out: ^TagLib_Complex_Property_Picture_Data) ---
    complex_property_free_keys :: proc(keys: ^^cstring) ---
    complex_property_free :: proc(props: ^^^TagLib_Complex_Property_Attribute) ---
}
