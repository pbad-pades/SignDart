import '../utils/hash_helper.dart';

import '../curves/curve.dart';
import '../point/point.dart';

class TwistedEdwardCurve implements Curve {
  @override
  late final String curveName;

  @override
  late final BigInt field;

  @override
  late final BigInt order;

  @override
  late final BigInt a;

  @override
  late final BigInt d;

  @override
  late final Point generator;

  @override
  late final int cofactor;

  @override
  late final Shake256 hash;

  @override
  late final int keySize;

  @override
  late final int signatureSize;
  
  TwistedEdwardCurve.ed521() {
    this.curveName = 'Ed521';

    this.field = BigInt.parse(
    '6864797660130609714981900799081393217269435300143305409394463459185543183397656052122559640661454554977296311391480858037121987999716643812574028291115057151'
    );

    this.order = BigInt.parse(
    '1716199415032652428745475199770348304317358825035826352348615864796385795849413675475876651663657849636693659065234142604319282948702542317993421293670108523'
    );

    this.a = BigInt.from(0x01); 

    this.d = BigInt.parse(
    '6864797660130609714981900799081393217269435300143305409394463459185543183397656052122559640661454554977296311391480858037121987999716643812574028291114681137'
    );

    this.generator = Point(
      BigInt.parse(
        '1571054894184995387535939749894317568645297350402905821437625181152304994381188529632591196067604100772673927915114267193389905003276673749012051148356041324'
      ),
      BigInt.parse(
        '12'
      ),
        this,
        false
    );

    this.cofactor = 0x04;

    this.hash = Shake256();

    this.keySize = 66;

    this.signatureSize = keySize * 2;
  }

  /// Verify if the point is on the curve
  @override
  bool isOnCurve(Point P) {
    // a * x^2 + y^2 ≡ 1 + d * x^2 * y^2
    
    BigInt left = (this.a * (P.x * P.x) + (P.y* P.y)) % this.field;
    BigInt right = (BigInt.one + this.d * (P.x * P.x) + (P.y * P.y)) % this.field;

    return left == right;
  }

  @override
  Point mulPoint(BigInt k, Point P) {
    var q = this.field;
    var coefficientA = this.a;
    
    var result = _aff2ext(P.x, P.y, q);
    var x1 = result[0], y1 = result[1], z1 = result[2], t1 = result[3];
    
    var kBits = k.toRadixString(2);
    var sz = kBits.length;
    
    result = _dblExt(x1,y1,z1,t1, q, coefficientA);
    var x2 = result[0], y2 = result[1], z2 = result[2], t2 = result[3];

    for (var i = 1; i < sz; i++) {
      if (kBits[i] == '1') {
        result = _addExt(x2,y2,z2,t2, x1,y1,z1,t1, q, coefficientA);
        x1 = result[0]; y1 = result[1]; z1 = result[2]; t1 = result[3]; 

        result = _dblExt(x2,y2,z2,t2, q, coefficientA);
        x2 = result[0]; y2 = result[1]; z2 = result[2]; t2 = result[3]; 
      } else {
        result = _addExt(x1,y1,z1,t1, x2,y2,z2,t2, q, coefficientA);
        x2 = result[0]; y2 = result[1]; z2 = result[2]; t2 = result[3];

        result = _dblExt(x1,y1,z1,t1, q, coefficientA);
        x1 = result[0]; y1 = result[1]; z1 = result[2]; t1 = result[3]; 
      }
    }
    if (z1 != null) {
      result = _ext2aff(x1,y1,z1,t1, q);
      var x = result[0], y = result[1];
      return Point(x, y, this);
    }

    return Point(BigInt.zero, BigInt.zero, this, false);
  }

  List _aff2ext(x, y, q){
    var z = BigInt.one;
    var t = (x*y*z) % q;
    x = (x*z) % q;
    y = (y*z) % q;
    return [x,y,z,t];
  }

  List _dblExt(BigInt x1, BigInt y1, BigInt z1, BigInt xy1, BigInt q, BigInt a){
    var A  = (x1*x1)%q;
    var B  = (y1*y1)%q;
    var C  = (BigInt.two*z1*z1)%q;
    var D  = (a*A)%q;
    var E  = ((x1+y1)*(x1+y1)-A-B)%q;
    var G  = (D+B)%q;
    var F  = (G-C)%q;
    var H  = (D-B)%q;
    var x3  = (E*F)%q;
    var y3  = (G*H)%q;
    var xy3 = (E*H)%q;
    var z3  = (F*G)%q;

    return [x3,y3,z3,xy3];
  }

  List _addExt(BigInt x1,BigInt y1,BigInt z1,BigInt xy1,  BigInt x2,BigInt y2,BigInt z2,BigInt xy2, BigInt q,BigInt a){
    var A = (x1*x2)%q;
    var B = (y1*y2)%q;
    var C = (z1*xy2)%q;
    var D = (xy1*z2)%q;
    var E = (D+C)%q;
    var t0 = (x1-y1)%q;
    var t1 = (x2+y2)%q;
    var t2 = (t0*t1)%q;
    var t3 = (t2+B)%q;
    var F = (t3-A)%q;
    var t4 = (a*A)%q;
    var G = (B+t4)%q;
    var H = (D-C)%q;
    var x3 = (E*F)%q;
    var y3 = (G*H)%q;
    var xy3 = (E*H)%q;
    var z3 = (F*G)%q;
    return [x3,y3,z3,xy3];
  }

  List _ext2aff(BigInt x, BigInt y, BigInt z, BigInt xy, BigInt q) {
  
    var invz = z.modPow(q - BigInt.two, q);
    x = (x*invz)%q;
    y = (y*invz)%q;
    return [x,y];
  }
}