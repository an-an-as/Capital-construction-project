int searchItem(int arr[],int len, int value){
    int low = 0,high = len-1,mid;
    while (low <= high) {
        mid = (low + high)/2;
        if (value > arr[mid]) {
            low = mid+1;
        }else if (value < arr[mid]){
            high = mid - 1;
        }else{
            return mid;
        }
    }
    return -1;
}
