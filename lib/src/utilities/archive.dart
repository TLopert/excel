part of excel;

Archive _cloneArchive(
    Archive archive,
    Map<String, ArchiveFile> _archiveFiles, {
      String? excludedFile,
    }) {
  final clone = Archive();

  for (final file in archive.files) {
    if (!file.isFile) continue;

    if (excludedFile != null &&
        file.name.toLowerCase() == excludedFile.toLowerCase()) {
      continue;
    }

    ArchiveFile copy;

    if (_archiveFiles.containsKey(file.name)) {
      copy = _archiveFiles[file.name]!;
    } else {
      final content = file.content as Uint8List;
      final shouldCompress = !_noCompression.contains(file.name);

      if (shouldCompress) {
        // This constructor uses DEFLATE compression by default
        copy = ArchiveFile(file.name, content.length, content);
      } else {
        copy = ArchiveFile.noCompress(file.name, content.length, content);
      }
    }

    clone.addFile(copy);
  }

  return clone;
}

