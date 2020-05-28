class PagingDataDTO<T> {
  int total;
  List<T> data;

  PagingDataDTO({
    this.total,
    this.data
  });
}