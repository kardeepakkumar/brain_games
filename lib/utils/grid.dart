class Grid {

  static List<List<int>> cloneGrid(List<List<int>> grid) {
    return grid.map<List<int>>((row) => List<int>.from(row)).toList();
  }

  static bool areGridsEqual(List<List<int>> grid1, List<List<int>> grid2) {
    if ((grid1.length != grid2.length) || (grid1[0].length != grid2[0].length)) {
      throw Error();
    }
    for (int i = 0; i < grid1.length; i++) {
      for (int j = 0; j < grid1[0].length; j++) {
        if (grid1[i][j] != grid2[i][j]) return false;
      }
    }
    return true;
  }
}