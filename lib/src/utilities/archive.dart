part of excel;

Archive _cloneArchive(
  Archive archive,
  Map<String, ArchiveFile> _archiveFiles, {
  String? excludedFile,
}) {
  var clone = Archive();
  archive.files.forEach((file) {
    if (file.isFile) {
      if (excludedFile != null &&
          file.name.toLowerCase() == excludedFile.toLowerCase()) {
        return;
      }
      ArchiveFile copy;
      if (_archiveFiles.containsKey(file.name)) {
        copy = _archiveFiles[file.name]!;
      } else {
        var content = file.content as Uint8List;
        var compress = !_noCompression.contains(file.name);

        // Create ArchiveFile with the new API
        copy = ArchiveFile.noCompress(file.name, content.length, content);

        // Apply compression if needed
        if (compress) {
          // Create a compressed version of the file
          var compressedData = ZLibEncoder().encode(content);
          copy = ArchiveFile.noCompress(
              file.name, compressedData.length, compressedData);
        }
      }
      clone.addFile(copy);
    }
  });
  return clone;
}
