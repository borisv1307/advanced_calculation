import 'package:advanced_calculation/display_style.dart';
import 'package:advanced_calculation/src/transform/display_style_transformer.dart';
import 'package:test/test.dart';

void main(){
  DisplayStyleTransformer transformer;

  setUp((){
    transformer = DisplayStyleTransformer();
  });

  group('Normal',(){
    test('Whole number remains whole',(){
      expect(transformer.transform('10', DisplayStyle.NORMAL),'10');
    });

    test('Decimals',(){
      expect(transformer.transform('33.3', DisplayStyle.NORMAL),'33.3');
    });
  });

  group('Scientific',(){
    test('Whole number reduced',(){
      expect(transformer.transform('10', DisplayStyle.SCIENTIFIC),'1E1');
    });

    test('Decimal not reduced',(){
      expect(transformer.transform('3.3', DisplayStyle.SCIENTIFIC),'3.3E0');
    });

    test('Decimal reduced',(){
      expect(transformer.transform('33.3', DisplayStyle.SCIENTIFIC),'3.33E1');
    });

    test('Created decimal',(){
      expect(transformer.transform('33', DisplayStyle.SCIENTIFIC),'3.3E1');
    });

    test('Larger created decimal',(){
      expect(transformer.transform('510', DisplayStyle.SCIENTIFIC),'5.1E2');
    });

    test('Zero',(){
      expect(transformer.transform('0.0', DisplayStyle.SCIENTIFIC),'0E0');
    });
  });

  group('Engineering',(){
    test('Number below power of 3',(){
      expect(transformer.transform('100', DisplayStyle.ENGINEERING),'100E0');
    });

    test('power of 3',(){
      expect(transformer.transform('1000', DisplayStyle.ENGINEERING),'1E3');
    });

    test('power above 3',(){
      expect(transformer.transform('10000', DisplayStyle.ENGINEERING),'10E3');
    });
  });
}