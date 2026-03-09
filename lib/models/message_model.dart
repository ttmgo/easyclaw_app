class MessageModel {
  final int id;
  final String role; // 'user' or 'assistant'
  final String agentId;
  final String content;
  final String? type; // 'rich-text', 'data-table', etc.
  final AttachmentModel? attachment;
  final List<TableRowModel>? tableData;

  MessageModel({
    required this.id,
    required this.role,
    required this.agentId,
    required this.content,
    this.type,
    this.attachment,
    this.tableData,
  });
}

class AttachmentModel {
  final String type; // 'image'
  final String url;
  final String caption;

  AttachmentModel({
    required this.type,
    required this.url,
    required this.caption,
  });
}

class TableRowModel {
  final String item;
  final String value;
  final String status;

  TableRowModel({
    required this.item,
    required this.value,
    required this.status,
  });
}
