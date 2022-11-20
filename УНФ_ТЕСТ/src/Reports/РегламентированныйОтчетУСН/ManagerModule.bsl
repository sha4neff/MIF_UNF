#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ВерсияФорматаВыгрузки(Знач НаДату = Неопределено, ВыбраннаяФорма = Неопределено) Экспорт
	
	Если НаДату = Неопределено Тогда
		НаДату = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если НаДату >= '20090101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия500;
	ИначеЕсли НаДату >= '20050101' Тогда
		Возврат Перечисления.ВерсииФорматовВыгрузки.Версия300;
	КонецЕсли;
	
КонецФункции

Функция ТаблицаФормОтчета() Экспорт
	
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(254));
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить(Тип("Дата"));
	ОписаниеТиповДата = Новый ОписаниеТипов(МассивТипов, , Новый КвалификаторыДаты(ЧастиДаты.Дата));
	
	ТаблицаФормОтчета = Новый ТаблицаЗначений;
	ТаблицаФормОтчета.Колонки.Добавить("ФормаОтчета",        ОписаниеТиповСтрока);
	ТаблицаФормОтчета.Колонки.Добавить("ОписаниеОтчета",     ОписаниеТиповСтрока, "Утверждена",  20);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаНачалоДействия", ОписаниеТиповДата,   "Действует с", 5);
	ТаблицаФормОтчета.Колонки.Добавить("ДатаКонецДействия",  ОписаниеТиповДата,   "         по", 5);
	ТаблицаФормОтчета.Колонки.Добавить("РедакцияФормы",      ОписаниеТиповСтрока, "Редакция формы", 20);
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв1";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина РФ от 22.06.2009 № 58н.";
	НоваяФорма.РедакцияФормы      = "от 22.06.2009 № 58н.";
	НоваяФорма.ДатаНачалоДействия = '20090101';
	НоваяФорма.ДатаКонецДействия  = '20101231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2009Кв1";
	НоваяФорма.ОписаниеОтчета     = "Утверждена приказом Минфина РФ от 22.06.2009 № 58н (в ред. приказа Минфина РФ от 20.04.2011 № 48н).";
	НоваяФорма.РедакцияФормы      = "от 20.04.2011 № 48н.";
	НоваяФорма.ДатаНачалоДействия = '20110101';
	НоваяФорма.ДатаКонецДействия  = '20131231';
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2015Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 26.02.2016 № ММВ-7-3/99@.";
	НоваяФорма.РедакцияФормы      = "от 26.02.2016 № ММВ-7-3/99@.";
	НоваяФорма.ДатаНачалоДействия = '20150101';
	НоваяФорма.ДатаКонецДействия  = РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа(Тип("Дата"));
	
	НоваяФорма = ТаблицаФормОтчета.Добавить();
	НоваяФорма.ФормаОтчета        = "ФормаОтчета2014Кв1";
	НоваяФорма.ОписаниеОтчета     = "Приложение № 1 к приказу ФНС России от 04.07.2014 № ММВ-7-3/352@.";
	НоваяФорма.РедакцияФормы      = "от 04.07.2014 № ММВ-7-3/352@.";
	НоваяФорма.ДатаНачалоДействия = '20140101';
	НоваяФорма.ДатаКонецДействия  = '20151231';
	
	Возврат ТаблицаФормОтчета;
	
КонецФункции

Функция ДанныеРеглОтчета(ЭкземплярРеглОтчета) Экспорт
	
	ТаблицаДанныхРеглОтчета = ИнтерфейсыВзаимодействияБРО.НовыйТаблицаДанныхРеглОтчета();
	
	Период = ЭкземплярРеглОтчета.ДатаОкончания;
	
	Если ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2015Кв1"
		ИЛИ ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2014Кв1" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Раздел 1.1.
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел11") Тогда
			
			НалогКУплате11 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел11;
			
			// Коды ОКТМО.
			КодСтрокиОКТМО11_010 = "П000110001003";
			КодСтрокиОКТМО11_030 = "П000110003003";
			КодСтрокиОКТМО11_060 = "П000110006003";
			КодСтрокиОКТМО11_090 = "П000110009003";
			
			Если ЗначениеЗаполнено(НалогКУплате11[КодСтрокиОКТМО11_090]) Тогда
				ОКТМО11 = НалогКУплате11[КодСтрокиОКТМО11_090];
			ИначеЕсли ЗначениеЗаполнено(НалогКУплате11[КодСтрокиОКТМО11_060]) Тогда
				ОКТМО11 = НалогКУплате11[КодСтрокиОКТМО11_060];
			ИначеЕсли ЗначениеЗаполнено(НалогКУплате11[КодСтрокиОКТМО11_030]) Тогда
				ОКТМО11 = НалогКУплате11[КодСтрокиОКТМО11_030];
			Иначе
				ОКТМО11 = НалогКУплате11[КодСтрокиОКТМО11_010];
			КонецЕсли;
			
			КодСтрокиСуммаПодлежащаяДоплате11 = "П000110010003"; //сумма налога, подлежащая доплате
			
			Если ЗначениеЗаполнено(НалогКУплате11[КодСтрокиСуммаПодлежащаяДоплате11]) Тогда
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.ВидНалога = Перечисления.ВидыНалогов.УСН_Доходы;
				Сумма.Период = Период;
				Сумма.ОКАТО  = ОКТМО11;
				Сумма.Сумма  = НалогКУплате11[КодСтрокиСуммаПодлежащаяДоплате11];
			КонецЕсли;
			
		КонецЕсли;
		
		// Раздел 1.2.
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел12") Тогда
			
			НалогКУплате12 = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел12;
			
			// Коды ОКТМО.
			КодСтрокиОКТМО12_010 = "П000120001003";
			КодСтрокиОКТМО12_030 = "П000120003003";
			КодСтрокиОКТМО12_060 = "П000120006003";
			КодСтрокиОКТМО12_090 = "П000120009003";
			
			Если ЗначениеЗаполнено(НалогКУплате12[КодСтрокиОКТМО12_090]) Тогда
				ОКТМО12 = НалогКУплате12[КодСтрокиОКТМО12_090];
			ИначеЕсли ЗначениеЗаполнено(НалогКУплате12[КодСтрокиОКТМО12_060]) Тогда
				ОКТМО12 = НалогКУплате12[КодСтрокиОКТМО12_060];
			ИначеЕсли ЗначениеЗаполнено(НалогКУплате12[КодСтрокиОКТМО12_030]) Тогда
				ОКТМО12 = НалогКУплате12[КодСтрокиОКТМО12_030];
			Иначе
				ОКТМО12 = НалогКУплате12[КодСтрокиОКТМО12_010];
			КонецЕсли;
			
			КодСтрокиСуммаПодлежащаяДоплате12 = "П000120010003"; //сумма налога, подлежащая доплате
			
			Если ЗначениеЗаполнено(НалогКУплате12[КодСтрокиСуммаПодлежащаяДоплате12]) Тогда
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.ВидНалога = Перечисления.ВидыНалогов.УСН_ДоходыМинусРасходы;
				Сумма.Период = Период;
				Сумма.ОКАТО  = ОКТМО12;
				Сумма.Сумма  = НалогКУплате12[КодСтрокиСуммаПодлежащаяДоплате12];
			КонецЕсли;
			
			КодСтрокиСуммаМинНалога12 = "П000120012003"; //сумма мин. налога, подлежащая уплате
			
			Если ЗначениеЗаполнено(НалогКУплате12[КодСтрокиСуммаМинНалога12]) Тогда
				Сумма = ТаблицаДанныхРеглОтчета.Добавить();
				Сумма.ВидНалога = Перечисления.ВидыНалогов.УСН_ДоходыМинусРасходы;
				Сумма.Период = Период;
				Сумма.ОКАТО  = ОКТМО12;
				Сумма.Сумма  = НалогКУплате12[КодСтрокиСуммаМинНалога12];
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ЭкземплярРеглОтчета.ВыбраннаяФорма = "ФормаОтчета2009Кв1" Тогда
		
		ДанныеРеглОтчета = ЭкземплярРеглОтчета.ДанныеОтчета.Получить();
		Если ТипЗнч(ДанныеРеглОтчета) <> Тип("Структура") Тогда
			Возврат ТаблицаДанныхРеглОтчета;
		КонецЕсли;
		
		// Раздел 1.
		// 010 - код ОКАТО
		// 020 - КБК налога
		// 060 - сумма
		// 080 - КБК минимального налога
		// 090 - сумма минимального налога
		
		Если ДанныеРеглОтчета.ПоказателиОтчета.Свойство("ПолеТабличногоДокументаРаздел1") Тогда
			
			НалогКУплате = ДанныеРеглОтчета.ПоказателиОтчета.ПолеТабличногоДокументаРаздел1;
			
			КодСтрокиОКАТО                   = "П000010002003";
			КодСтрокиКБК                     = "П000010002003";
			КодСтрокиСумма                   = "П000010006003";
			КодСтрокиКБКМинимальногоНалога   = "П000010008003";
			КодСтрокиСуммаМинимальногоНалога = "П000010009003";
			
			// Налог.
			Сумма = ТаблицаДанныхРеглОтчета.Добавить();
			Сумма.Период = Период;
			Сумма.ОКАТО  = НалогКУплате[КодСтрокиОКАТО];
			Сумма.КБК    = НалогКУплате[КодСтрокиКБК];
			Сумма.Сумма  = НалогКУплате[КодСтрокиСумма];
			
			// Минимальный налог.
			Сумма = ТаблицаДанныхРеглОтчета.Добавить();
			Сумма.Период = Период;
			Сумма.ОКАТО  = НалогКУплате[КодСтрокиОКАТО];
			Сумма.КБК    = НалогКУплате[КодСтрокиКБКМинимальногоНалога];
			Сумма.Сумма  = НалогКУплате[КодСтрокиСуммаМинимальногоНалога];
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаДанныхРеглОтчета;
	
КонецФункции

Функция ДеревоФормИФорматов() Экспорт
	
	ФормыИФорматы = Новый ДеревоЗначений;
	ФормыИФорматы.Колонки.Добавить("Код");
	ФормыИФорматы.Колонки.Добавить("ДатаПриказа");
	ФормыИФорматы.Колонки.Добавить("НомерПриказа");
	ФормыИФорматы.Колонки.Добавить("ДатаНачалаДействия");
	ФормыИФорматы.Колонки.Добавить("ДатаОкончанияДействия");
	ФормыИФорматы.Колонки.Добавить("ИмяОбъекта");
	ФормыИФорматы.Колонки.Добавить("Описание");
	
	Форма20090101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152017", '20090622', "58н", "ФормаОтчета2009Кв1", , '20101231');
	ОпределитьФорматВДеревеФормИФорматов(Форма20090101, "5.01", , , , '20101231');
	
	Форма20110101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152017", '20110420', "48н", "ФормаОтчета2009Кв1", '20110101');
	ОпределитьФорматВДеревеФормИФорматов(Форма20110101, "5.02", , , '2011-01-01', '2012-12-31');
	ОпределитьФорматВДеревеФормИФорматов(Форма20110101, "5.03", , , '2013-01-01', '2013-12-31');
	
	Форма20140101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152017", '20140704', "ММВ-7-3/352@", "ФормаОтчета2014Кв1", '20140101');
	ОпределитьФорматВДеревеФормИФорматов(Форма20140101, "5.04", , , '2014-01-01');
	
	Форма20150101 = ОпределитьФормуВДеревеФормИФорматов(ФормыИФорматы, "1152017", '20160226', "ММВ-7-3/99@", "ФормаОтчета2015Кв1", '20150101');
	ОпределитьФорматВДеревеФормИФорматов(Форма20150101, "5.05", , , '2015-01-01');
	
	Возврат ФормыИФорматы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОпределитьФормуВДеревеФормИФорматов(ДеревоФормИФорматов, Код, ДатаПриказа = '00010101', НомерПриказа = "", ИмяОбъекта = "",
			ДатаНачалаДействия = '00010101', ДатаОкончанияДействия = '00010101', Описание = "")
	
	НовСтр = ДеревоФормИФорматов.Строки.Добавить();
	НовСтр.Код = СокрЛП(Код);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ДатаНачалаДействия;
	НовСтр.ДатаОкончанияДействия = ДатаОкончанияДействия;
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

Функция ОпределитьФорматВДеревеФормИФорматов(Форма, Версия, ДатаПриказа = '00010101', НомерПриказа = "",
			ДатаНачалаДействия = Неопределено, ДатаОкончанияДействия = Неопределено, ИмяОбъекта = "", Описание = "")
	
	НовСтр = Форма.Строки.Добавить();
	НовСтр.Код = СокрЛП(Версия);
	НовСтр.ДатаПриказа = ДатаПриказа;
	НовСтр.НомерПриказа = СокрЛП(НомерПриказа);
	НовСтр.ДатаНачалаДействия = ?(ДатаНачалаДействия = Неопределено, Форма.ДатаНачалаДействия, ДатаНачалаДействия);
	НовСтр.ДатаОкончанияДействия = ?(ДатаОкончанияДействия = Неопределено, Форма.ДатаОкончанияДействия, ДатаОкончанияДействия);
	НовСтр.ИмяОбъекта = СокрЛП(ИмяОбъекта);
	НовСтр.Описание = СокрЛП(Описание);
	Возврат НовСтр;
	
КонецФункции

#КонецОбласти

#КонецЕсли