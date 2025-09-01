function y = custom_fp(x, fp_e_width, fp_m_width)
    fp_e_width_exp = power(2.0, fp_e_width);
    fp_m_width_exp=power(2.0, fp_m_width);
    fp_exp_range = power(2.0, fp_e_width) / 2 ;
    fp_max_range = power(2.0, fp_exp_range);
    fp_max_data = (1 + (power(2.0, fp_m_width) - 1) / power(2.0, fp_m_width)) * fp_max_range;
    fp_min_data = power(2.0, -fp_exp_range+2);
    denormal_unit_reci=power(2.0, fp_m_width+fp_exp_range-2);

    x=min(fp_max_data, max(-fp_max_data, x));
    mask=(x>0) & (x<fp_min_data);
    x(mask)=denormal(x(mask), denormal_unit_reci);
    mask=(x<0) & (x>-fp_min_data);
    x(mask)=-denormal(-x(mask), denormal_unit_reci);

    mask=(x==0);
    sign_ = sign(x);
    x=x*sign_;
    exp = floor(log2(x));
    man = round(fp_m_width_exp * (x * power(2.0, -exp)));
    y=sign_*man/fp_m_width_exp * power(2.0, exp);
    y(mask)=0;
end

function y = denormal(x, denormal_unit_reci)
    y = round(x*denormal_unit_reci)/denormal_unit_reci;
end
