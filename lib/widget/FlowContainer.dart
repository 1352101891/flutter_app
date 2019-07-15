import 'package:flutter/widgets.dart';

class FlowContainer extends Flow{
  final delegate;

  FlowContainer({
    Key key,
    @required this.delegate,
    List<Widget> children = const <Widget>[],
  }) : assert(delegate != null),super(key:key,delegate:delegate,children:children);

}


class MyFlowDelegate extends FlowDelegate{
  EdgeInsets _childMargin= EdgeInsets.all(5);

  MyFlowDelegate({EdgeInsets childMargin}){
    if(childMargin!=null){
      this._childMargin=childMargin;
    }
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    var offsetX= _childMargin.left;
    var offsetY= _childMargin.top;
    var winSizeWidth= context.size.width;
    for(int i=0;i<context.childCount;i++){
      var cw= offsetX+context.getChildSize(i).width+_childMargin.right;
      //如果当前宽度大于屏幕宽度，则换行
      if(cw>=winSizeWidth){
        //换行，x从头开始
        offsetX= _childMargin.left;
        //换行行高加margin高
        offsetY+= _childMargin.bottom+_childMargin.top+context.getChildSize(i).height;
        context.paintChild(i,
          transform: new Matrix4.translationValues(offsetX,offsetY, 0));
        offsetX+= context.getChildSize(i).width+ _childMargin.right;
      }else{//小于宽度，继续向后添加子view
        context.paintChild(i,
          transform: new Matrix4.translationValues(offsetX,offsetY, 0));
        //绘制完成之后，偏移量修正到下一个位置
        offsetX = cw;
      }
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

}