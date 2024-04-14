import 'package:flutter/material.dart';
import 'package:flutter_application/utils/global.colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            '— or log in with —',
            style: TextStyle(
              color: GlobalColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            children: [
              //// Google
              Expanded(
                child:ClipOval(
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: GlobalColors.mainColor.withOpacity(0.9),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: (){
                        //Handle Google sign in
                      },
                      child: SvgPicture.asset(
                        'assets/icons/google.svg', 
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
                //// Twitter
              Expanded(
                child:ClipOval(
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: GlobalColors.mainColor.withOpacity(0.9),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: (){
                        //Handle Twitter sign in
                      },
                      child: SvgPicture.asset(
                        'assets/icons/twitter.svg', 
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ),
                const SizedBox(width: 10,),
                //// Facebook
                Expanded(
                child:ClipOval(
                  child: Container(
                    alignment: Alignment.center,
                    height: 55,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: GlobalColors.mainColor.withOpacity(0.9),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: (){
                        //Handle Facebook sign in
                      },
                      child: SvgPicture.asset(
                        'assets/icons/facebook.svg', 
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}