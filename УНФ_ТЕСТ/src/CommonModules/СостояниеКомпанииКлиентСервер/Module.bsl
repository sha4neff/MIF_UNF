
#Область ПрограммныйИнтерфейс

Функция ОписанияВсехСекций() Экспорт
	
	Результат = Новый Структура;
	ДобавитьОписаниеСекции(Результат, "ЧистыеАктивы", НСтр("ru = 'Чистые активы'"), ПоляФильтровЧистыеАктивы());
	ДобавитьОписаниеСекции(Результат, "Деньги", НСтр("ru = 'Деньги'"), ПоляФильтровДеньги());
	ДобавитьОписаниеСекции(Результат, "Товары", НСтр("ru = 'Товары'"), ПоляФильтровТовары());
	ДобавитьОписаниеСекции(Результат, "ТоварыНаСобственныхСкладах", НСтр("ru = 'Товары на собственных складах'"), ПоляФильтровТоварыНаСобственныхСкладах());
	ДобавитьОписаниеСекции(Результат, "ТоварыУРеализаторов", НСтр("ru = 'Товары у реализаторов'"), ПоляФильтровТоварыУРеализаторов());
	ДобавитьОписаниеСекции(Результат, "ДебиторкаДолгиПокупателей", НСтр("ru = 'Долги покупателей'"), ПоляФильтровДебиторкаДолгиПокупателей());
	ДобавитьОписаниеСекции(Результат, "ДебиторкаАвансыПоставщикам", НСтр("ru = 'Авансы поставщикам'"), ПоляФильтровДебиторкаАвансыПоставщикам());
	ДобавитьОписаниеСекции(Результат, "КредиторкаДолгиПоставщикам", НСтр("ru = 'Долги поставщикам'"), ПоляФильтровКредиторкаДолгиПоставщикам());
	ДобавитьОписаниеСекции(Результат, "КредиторкаАвансыОтПокупателей", НСтр("ru = 'Авансы от покупателей'"), ПоляФильтровКредиторкаАвансыОтПокупателей());
	ДобавитьОписаниеСекции(Результат, "ПродажиВыручка", НСтр("ru = 'Продажи (выручка)'"), ПоляФильтровПродажиВыручка());
	ДобавитьОписаниеСекции(Результат, "ПродажиКоличество", НСтр("ru = 'Продажи (количество)'"), ПоляФильтровПродажиКоличество());
	ДобавитьОписаниеСекции(Результат, "ПродажиДинамика", НСтр("ru = 'Продажи (динамика)'"), ПоляФильтровПродажиДинамика());
	ДобавитьОписаниеСекции(Результат, "ПродажиПокупатели", НСтр("ru = 'Покупатели, давшие 80% выручки за последние 365 дней'"), ПоляФильтровПродажиПокупатели());
	ДобавитьОписаниеСекции(Результат, "ПродажиСамыеПродаваемыеТовары", НСтр("ru = 'ТОП-10 самых продаваемых товаров за последние 365 дней'"), ПоляФильтровПродажиСамыеПродаваемыеТовары());
	
	Возврат Результат;
	
КонецФункции

Функция ВариантыПредварительногоПросмотра() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("НаЭкране", "СостояниеКомпании.ИнтерактивноПодготовитьОтчетДляПросмотраНаЭкране");
	Результат.Вставить("ПоЭлектроннойПочте", "СостояниеКомпании.ИнтерактивноОтправитьОтчетПоЭлектроннойПочте");
	
	Возврат Результат;
	
КонецФункции

Функция ВидСравненияСтрока(ВидСравненияКД) Экспорт
	
	ВариантыВидовСравнения = Новый Соответствие;
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.Больше] = "Больше";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.БольшеИлиРавно] = "БольшеИлиРавно";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.ВИерархии] = "ВИерархии";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.ВСписке] = "ВСписке";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии] = "ВСпискеПоИерархии";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.Заполнено] = "Заполнено";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.Меньше] = "Меньше";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.МеньшеИлиРавно] = "МеньшеИлиРавно";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.НачинаетсяС] = "НачинаетсяС";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.НеВИерархии] = "НеВИерархии";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.НеВСписке] = "НеВСписке";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.НеЗаполнено] = "НеЗаполнено";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.НеНачинаетсяС] = "НеНачинаетсяС";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.НеПодобно] = "НеПодобно";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.НеРавно] = "НеРавно";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.НеСодержит] = "НеСодержит";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.Подобно] = "Подобно";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.Равно] = "Равно";
	ВариантыВидовСравнения[ВидСравненияКомпоновкиДанных.Содержит] = "Содержит";
	
	Возврат ВариантыВидовСравнения[ВидСравненияКД];
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьОписаниеСекции(Знач ОписанияВсехСекций, Знач ТипСекции, Знач ЗаголовокСекции, Знач ПоляФильтров)
	
	ОписаниеСекции = Новый Структура;
	ОписаниеСекции.Вставить("ЗаголовокСекции", ЗаголовокСекции);
	ОписаниеСекции.Вставить("ПоляФильтров", ПоляФильтров);
	
	ОписанияВсехСекций.Вставить(ТипСекции, ОписаниеСекции);
	
КонецПроцедуры

Процедура ДобавитьПолеФильтра(ПоляФильтров, ИмяОбласти, ИмяПоля, Путь, ПредставлениеПоля, ТипПоля)
	
	ОписаниеПоляФильтра = Новый Структура;
	ОписаниеПоляФильтра.Вставить("ИмяОбласти", ИмяОбласти);
	ОписаниеПоляФильтра.Вставить("Путь", Путь);
	ОписаниеПоляФильтра.Вставить("ПредставлениеПоля", ПредставлениеПоля);
	ОписаниеПоляФильтра.Вставить("ТипПоля", ТипПоля);
	
	ПоляФильтров.Вставить(ИмяПоля, ОписаниеПоляФильтра);
	
КонецПроцедуры

Функция ПоляФильтровЧистыеАктивы()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Счет", "Счет", НСтр("ru = 'Счет'"), Новый ОписаниеТипов("ПланСчетовСсылка.Управленческий"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "ТипСчета", "Счет.ТипСчета", НСтр("ru = 'Тип счета'"), Новый ОписаниеТипов("ПеречислениеСсылка.ТипыСчетов"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровДеньги()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "ФильтрыБанковскиеСчета", "БанковскийСчет", "БанковскийСчетКасса", НСтр("ru = 'Банковский счет'"), Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета"));
	ДобавитьПолеФильтра(Результат, "ФильтрыКассы", "Касса", "БанковскийСчетКасса", НСтр("ru = 'Касса'"), Новый ОписаниеТипов("СправочникСсылка.Кассы"));
	ДобавитьПолеФильтра(Результат, "ФильтрыСотрудники", "Сотрудник", "Сотрудник", НСтр("ru = 'Сотрудник'"), Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровТовары()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Номенклатура", "Номенклатура", НСтр("ru = 'Номенклатура'"), Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "КатегорияТовара", "Номенклатура.КатегорияНоменклатуры", НСтр("ru = 'Категория'"), Новый ОписаниеТипов("СправочникСсылка.КатегорииНоменклатуры"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровТоварыНаСобственныхСкладах()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Номенклатура", "Номенклатура", НСтр("ru = 'Номенклатура'"), Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "КатегорияТовара", "Номенклатура.КатегорияНоменклатуры", НСтр("ru = 'Категория'"), Новый ОписаниеТипов("СправочникСсылка.КатегорииНоменклатуры"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "СтруктурнаяЕдиница", "СтруктурнаяЕдиница", НСтр("ru = 'Склад'"), Новый ОписаниеТипов("СправочникСсылка.СтруктурныеЕдиницы"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровТоварыУРеализаторов()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Номенклатура", "Номенклатура", НСтр("ru = 'Номенклатура'"), Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "КатегорияТовара", "Номенклатура.КатегорияНоменклатуры", НСтр("ru = 'Категория'"), Новый ОписаниеТипов("СправочникСсылка.КатегорииНоменклатуры"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "Контрагент", "Контрагент", НСтр("ru = 'Контрагент'"), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровДебиторкаДолгиПокупателей()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Контрагент", "Контрагент", НСтр("ru = 'Контрагент'"), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровДебиторкаАвансыПоставщикам()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Контрагент", "Контрагент", НСтр("ru = 'Контрагент'"), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровКредиторкаДолгиПоставщикам()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Контрагент", "Контрагент", НСтр("ru = 'Контрагент'"), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровКредиторкаАвансыОтПокупателей()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Контрагент", "Контрагент", НСтр("ru = 'Контрагент'"), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровПродажиВыручка()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Контрагент", "Контрагент", НСтр("ru = 'Контрагент'"), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "Номенклатура", "Номенклатура", НСтр("ru = 'Номенклатура'"), Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "КатегорияТовара", "Номенклатура.КатегорияНоменклатуры", НСтр("ru = 'Категория'"), Новый ОписаниеТипов("СправочникСсылка.КатегорииНоменклатуры"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровПродажиКоличество()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Контрагент", "Контрагент", НСтр("ru = 'Контрагент'"), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "Номенклатура", "Номенклатура", НСтр("ru = 'Номенклатура'"), Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "КатегорияТовара", "Номенклатура.КатегорияНоменклатуры", НСтр("ru = 'Категория'"), Новый ОписаниеТипов("СправочникСсылка.КатегорииНоменклатуры"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровПродажиДинамика()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Контрагент", "Контрагент", НСтр("ru = 'Контрагент'"), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "Номенклатура", "Номенклатура", НСтр("ru = 'Номенклатура'"), Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "КатегорияТовара", "Номенклатура.КатегорияНоменклатуры", НСтр("ru = 'Категория'"), Новый ОписаниеТипов("СправочникСсылка.КатегорииНоменклатуры"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровПродажиПокупатели()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Контрагент", "Контрагент", НСтр("ru = 'Контрагент'"), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	
	Возврат Результат;
	
КонецФункции

Функция ПоляФильтровПродажиСамыеПродаваемыеТовары()
	
	Результат = Новый Структура;
	
	ДобавитьПолеФильтра(Результат, "Фильтры", "Номенклатура", "Номенклатура", НСтр("ru = 'Номенклатура'"), Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ДобавитьПолеФильтра(Результат, "Фильтры", "КатегорияТовара", "Номенклатура.КатегорияНоменклатуры", НСтр("ru = 'Категория'"), Новый ОписаниеТипов("СправочникСсылка.КатегорииНоменклатуры"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти