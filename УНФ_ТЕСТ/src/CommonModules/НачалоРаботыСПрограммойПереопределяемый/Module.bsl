
Процедура ДозаполнитьПараметрыОткрытияФормы(ПараметрыОткрытия, ПараметрыНачалаРаботы) Экспорт
	
	
	
КонецПроцедуры

Процедура ОбработкаЗакрытияФормыНачалаРаботы(ЗначенияРеквизитов, ПараметрыНачалаРаботы, ОбработкаЗавершена) Экспорт
	
	ОбновитьПользователя(ЗначенияРеквизитов, ПараметрыНачалаРаботы);
	
	ВыполнитьЗаполнениеПоВидуБизнеса(ЗначенияРеквизитов);
	
	ОбновитьЗаписатьОрганизации(ЗначенияРеквизитов);
	
	ЗафиксироватьОкончаниеПервогоВходаВПрограмму(ПараметрыНачалаРаботы);
	
	ОбработкаЗавершена = Истина;
	
КонецПроцедуры

#Область УНФ

Функция ИмяСобытияЖР()
	
	Возврат НСтр("ru='Стартовое окно'")
	
КонецФункции

Процедура ОбновитьПользователя(ЗначенияРеквизитов, ПараметрыНачалаРаботы)
	Перем ПользовательСсылка, РазрешитьИнтерактивноеОткрытие;
	
	Если НЕ ЗначенияРеквизитов.Свойство("Пользователь", ПользовательСсылка)
		ИЛИ НЕ ЗначениеЗаполнено(ПользовательСсылка) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Если ПараметрыНачалаРаботы.РазделениеВключено Тогда
		
		ПользовательОбъект = ПользовательСсылка.ПолучитьОбъект();
		
	Иначе
		
		ПользовательОбъект = Справочники.Пользователи.СоздатьЭлемент();
		
		// Доступно только в локальном режиме
		ПользовательОбъект.Наименование = ЗначенияРеквизитов.ПользовательИмя;
		
		ОписаниеПользователяИБ = Новый Структура;
		ОписаниеПользователяИБ.Вставить("Действие",					"Записать");
		ОписаниеПользователяИБ.Вставить("Имя",						ЗначенияРеквизитов.ПользовательИмя);
		ОписаниеПользователяИБ.Вставить("ПолноеИмя",				ЗначенияРеквизитов.ПользовательИмя);
		ОписаниеПользователяИБ.Вставить("Пароль", 					ЗначенияРеквизитов.ПользовательПароль);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная",Истина);
		ОписаниеПользователяИБ.Вставить("ПарольУстановлен", 		Истина);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора",	Истина);
		
		ДоступныеРоли = Новый Массив;
		ДоступныеРоли.Добавить(Метаданные.Роли.АдминистраторСистемы.Имя);
		ДоступныеРоли.Добавить(Метаданные.Роли.ПолныеПрава.Имя);
		
		ОписаниеПользователяИБ.Вставить("Роли", ДоступныеРоли);
		
		ПользовательОбъект.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		ПользовательОбъект.ДополнительныеСвойства.Вставить("СозданиеАдминистратора", НСтр("ru = 'Создание первого администратора.'"));
		
		ПользовательОбъект.Служебный = Ложь;
		
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ЗначенияРеквизитов.ПользовательТелефон) Тогда
		ВидКИ = Справочники.ВидыКонтактнойИнформации.ТелефонПользователя;
		УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(ПользовательОбъект, ЗначенияРеквизитов.ПользовательТелефон, ВидКИ);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ЗначенияРеквизитов.ПользовательEmail) Тогда
		ВидКИ = Справочники.ВидыКонтактнойИнформации.EmailПользователя;
		УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(ПользовательОбъект, ЗначенияРеквизитов.ПользовательEmail, ВидКИ);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ЗначенияРеквизитов.ПользовательСайт) Тогда
		ВидКИ = Справочники.ВидыКонтактнойИнформации.СайтПользователя;
		УправлениеКонтактнойИнформацией.ДобавитьКонтактнуюИнформацию(ПользовательОбъект, ЗначенияРеквизитов.ПользовательСайт, ВидКИ);
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ПользовательОбъект, Ложь, Истина);
	
	Если ЗначенияРеквизитов.Свойство("РазрешитьИнтерактивноеОткрытие") Тогда
		Пользователи.УстановитьПравоОткрытияВнешнихОтчетовИОбработок(ЗначенияРеквизитов.РазрешитьИнтерактивноеОткрытие);
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ВыполнитьЗаполнениеПоВидуБизнеса(ЗначенияРеквизитов)
	
	Если НЕ ЗначенияРеквизитов.Свойство("ВидБизнесаОрганизации")
		ИЛИ ТипЗнч(ЗначенияРеквизитов.ВидБизнесаОрганизации) <> Тип("СписокЗначений")
		ИЛИ ЗначенияРеквизитов.ВидБизнесаОрганизации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		ВсеИдентификаторы = "";
		Для каждого ВидБизнеса Из ЗначенияРеквизитов.ВидБизнесаОрганизации Цикл
			
			ИдентификаторВидаБизнеса = ИдентификаторВидаБизнеса(ВидБизнеса.Значение);
			Если ИдентификаторВидаБизнеса = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Если ВсеИдентификаторы <> "" Тогда
				ВсеИдентификаторы = ВсеИдентификаторы + ";";
			КонецЕсли;
			ВсеИдентификаторы = ВсеИдентификаторы + ИдентификаторВидаБизнеса;
			
			ЗаполнитьНастройкиПоВидуБизнеса(ВидБизнеса.Значение);
			
		КонецЦикла;
		
		Если ВсеИдентификаторы <> "" Тогда
			Константы.ВидБизнесаОрганизации.Установить(ВсеИдентификаторы);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		// Не вызывать исключение, чтобы не нагружать пользователя при старте.
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		
	КонецПопытки;
	
КонецПроцедуры

Процедура ОбновитьЗаписатьОрганизации(ЗначенияРеквизитов)
	
	// ЗначенияРеквизитов.Организации.Выгрузить() - в толстом приводит к ошибке
	ТаблицаОрганизаций = Обработки.НачалоРаботыСПрограммой.Создать().Организации.Выгрузить(); 
	
	КоличествоОрганизаций = ЗначенияРеквизитов.Организации.Количество();
	Для Счетчик = 0 По КоличествоОрганизаций - 1 Цикл
		
		ЗаполнитьЗначенияСвойств(ТаблицаОрганизаций.Добавить(), ЗначенияРеквизитов.Организации[Счетчик]);
		
	КонецЦикла;
	
	Если КоличествоОрганизаций > 1 Тогда
		
		Константы.ИспользоватьНесколькоОрганизаций.Установить(Истина);
		Константы.НеИспользоватьНесколькоОрганизаций.Установить(Ложь);
		
	КонецЕсли;
	
	НачатьТранзакцию();
	Для каждого СтрокаОрганизации Из ТаблицаОрганизаций Цикл
		
		ОрганизацияОбъект = СтрокаОрганизации.Ссылка.ПолучитьОбъект();
		
		Если ОрганизацияОбъект = Неопределено Тогда
			
			ОрганизацияОбъект = Справочники.Организации.СоздатьЭлемент();
			ОрганизацияОбъект.УстановитьСсылкуНового(СтрокаОрганизации.Ссылка);
			
			ОрганизацияОбъект.ПроизводственныйКалендарь = УправлениеНебольшойФирмойСервер.ПолучитьКалендарьПоПроизводственномуКалендарюРФ(); 
		КонецЕсли;
		Если СтрокаОрганизации.СистемаНалогообложения = 0 Тогда
			ОрганизацияОбъект.ВидСтавкиНДСПоУмолчанию = Перечисления.ВидыСтавокНДС.Общая;
		Иначе
			ОрганизацияОбъект.ВидСтавкиНДСПоУмолчанию =  Перечисления.ВидыСтавокНДС.БезНДС;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(ОрганизацияОбъект, СтрокаОрганизации);
		
		Если ОрганизацияОбъект.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
			
			ОрганизацияОбъект.ИспользуетсяОтчетность = (СтрокаОрганизации.ЕстьУСН ИЛИ СтрокаОрганизации.ЕстьЕНВД);
			
			ФизическоеЛицо = Справочники.ФизическиеЛица.СоздатьЭлемент();
			ФизическоеЛицо.Наименование = СтрокаОрганизации.Фамилия
				+ ?(ПустаяСтрока(СтрокаОрганизации.Имя), "", " " + СтрокаОрганизации.Имя)
				+ ?(ПустаяСтрока(СтрокаОрганизации.Отчество), "", " " + СтрокаОрганизации.Отчество);
			ФизическоеЛицо.Записать();
			
			ОрганизацияОбъект.ФизическоеЛицо = ФизическоеЛицо.Ссылка;
			
			МенеджерЗаписиФизЛица = РегистрыСведений.ФИОФизЛиц.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МенеджерЗаписиФизЛица, СтрокаОрганизации, "Фамилия, Имя, Отчество");
			МенеджерЗаписиФизЛица.Период = '19800101';
			МенеджерЗаписиФизЛица.ФизЛицо = ФизическоеЛицо.Ссылка;
			МенеджерЗаписиФизЛица.Записать(Истина);
			
			МенеджерЗаписиДокументыФизЛиц = РегистрыСведений.ДокументыФизическихЛиц.СоздатьМенеджерЗаписи();
			МенеджерЗаписиДокументыФизЛиц.Период = '19800101';
			МенеджерЗаписиДокументыФизЛиц.ФизЛицо = ФизическоеЛицо.Ссылка;
			МенеджерЗаписиДокументыФизЛиц.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ;
			МенеджерЗаписиДокументыФизЛиц.ЯвляетсяДокументомУдостоверяющимЛичность = Истина;
			МенеджерЗаписиДокументыФизЛиц.Записать(Истина);
			
		КонецЕсли;
		
		МенеджерЗаписи = РегистрыСведений.СистемыНалогообложенияОрганизаций.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период = '20000101';
		МенеджерЗаписи.Организация = СтрокаОрганизации.Ссылка;
		МенеджерЗаписи.ПлательщикЕНВД = СтрокаОрганизации.ЕстьЕНВД;
		МенеджерЗаписи.ПрименяетсяПатент = СтрокаОрганизации.ЕстьПатент;
		
		Если СтрокаОрганизации.СистемаНалогообложения = 0 Тогда
			МенеджерЗаписи.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Общая;
			МенеджерЗаписи.ПлательщикУСН = Ложь;
			
		ИначеЕсли СтрокаОрганизации.СистемаНалогообложения = 1 Тогда
			
			МенеджерЗаписи.СистемаНалогообложения = Перечисления.СистемыНалогообложения.Упрощенная;
			МенеджерЗаписи.ПлательщикУСН = Истина;
			МенеджерЗаписи.ОбъектНалогообложения = СтрокаОрганизации.ВидыОбъектовНалогообложения;
			МенеджерЗаписи.СтавкаНалога = СтрокаОрганизации.СтавкаНалога;
			
		ИначеЕсли СтрокаОрганизации.СистемаНалогообложения = 2 ИЛИ 
			СтрокаОрганизации.СистемаНалогообложения = 3 Тогда
			МенеджерЗаписи.СистемаНалогообложения = Перечисления.СистемыНалогообложения.ОсобыйПорядок;
			МенеджерЗаписи.ПлательщикУСН = Ложь;
		КонецЕсли;
		
		Попытка
			
			ОрганизацияОбъект.Записать();
			МенеджерЗаписи.Записать(Истина);
			
		Исключение
			
			ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(ИмяСобытияЖР(), УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.Организации, ТекстОшибки, );
			
			ВызватьИсключение ОписаниеОшибки();
			
			ОтменитьТранзакцию();
			
		КонецПопытки;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ЗафиксироватьОкончаниеПервогоВходаВПрограмму(ПараметрыНачалаРаботы)
	
	Константы.ДатаПервогоВходаВСистему.Установить(ТекущаяДата());
	Константы.ВерсияНачалаРаботыСПрограммой.Установить(ПараметрыНачалаРаботы.ВерсияДанныхОсновнойКонфигурации);
	
КонецПроцедуры

Процедура ЗаполнитьНастройкиПоВидуБизнеса(ВидБизнеса)
	
	Если НЕ ЗначениеЗаполнено(ВидБизнеса) Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидБизнеса = "ОптоваяТорговля" Тогда
		
		Константы.ФункциональнаяОпцияИспользоватьРучныеСкидкиНаценкиПродажи.Установить(Истина);
		Константы.ФункциональнаяОпцияИспользоватьРучныеСкидкиНаценкиЗакупки.Установить(Истина);
		Константы.ФункциональнаяОпцияИспользоватьСверкиВзаиморасчетов.Установить(Истина);
		
	ИначеЕсли ВидБизнеса = "РозничнаяТорговля" Тогда
		
		Константы.ФункциональнаяОпцияУчетРозничныхПродаж.Установить(Истина);
		Константы.ФункциональнаяОпцияИспользоватьПечатьЭтикетокИЦенников.Установить(Истина);
		Константы.ФункциональнаяОпцияИспользоватьРучныеСкидкиНаценкиПродажи.Установить(Истина);
		Константы.ФункциональнаяОпцияИспользоватьРучныеСкидкиНаценкиЗакупки.Установить(Истина);
		Константы.ФункциональнаяОпцияИспользоватьДисконтныеКарты.Установить(Истина);
		Константы.ФункциональнаяОпцияИспользоватьАвтоматическиеСкидкиНаценки.Установить(Истина);
		ДисконтныеКартыСервер.ПроверитьИСоздатьУсловиеПоДисконтнойКарте();
		
	ИначеЕсли ВидБизнеса = "РаботыУслуги" Тогда
		
		Константы.ФункциональнаяОпцияИспользоватьПодсистемуРаботы.Установить(Истина);
		
	ИначеЕсли ВидБизнеса = "ИнтернетМагазин" Тогда
		
		Константы.ФункциональнаяОпцияИспользоватьОбменССайтами.Установить(Истина);
		
	ИначеЕсли ВидБизнеса = "Производство" Тогда
		
		Константы.ФункциональнаяОпцияИспользоватьПодсистемуПроизводство.Установить(Истина);
		Константы.ФункциональнаяОпцияИспользоватьТехоперации.Установить(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ВидыБизнеса()
	
	ВидыБизнеса = Новый Массив;
	
	ВидБизнесаОписание = Новый Структура;
	ВидБизнесаОписание.Вставить("Представление", НСтр("ru='Оптовая торговля'"));
	ВидБизнесаОписание.Вставить("Код",           "ОптоваяТорговля");
	ВидБизнесаОписание.Вставить("Идентификатор", "72c52f8c-ef35-46ec-9aa1-bf666b4dc336");
	ВидыБизнеса.Добавить(ВидБизнесаОписание);
	
	ВидБизнесаОписание = Новый Структура;
	ВидБизнесаОписание.Вставить("Представление", НСтр("ru='Розница'"));
	ВидБизнесаОписание.Вставить("Код",           "РозничнаяТорговля");
	ВидБизнесаОписание.Вставить("Идентификатор", "4d9eaf34-2c37-43d3-9fa0-d2611144a805");
	ВидыБизнеса.Добавить(ВидБизнесаОписание);
	
	ВидБизнесаОписание = Новый Структура;
	ВидБизнесаОписание.Вставить("Представление", НСтр("ru='Работы и услуги'"));
	ВидБизнесаОписание.Вставить("Код",           "РаботыУслуги");
	ВидБизнесаОписание.Вставить("Идентификатор", "fde119b3-1c23-4415-83d0-e19e527a2c26");
	ВидыБизнеса.Добавить(ВидБизнесаОписание);
	
	ВидБизнесаОписание = Новый Структура;
	ВидБизнесаОписание.Вставить("Представление", НСтр("ru='Интернет-магазин'"));
	ВидБизнесаОписание.Вставить("Код",           "ИнтернетМагазин");
	ВидБизнесаОписание.Вставить("Идентификатор", "13df7e69-33d5-4eba-b300-691b2d12ebf9");
	ВидыБизнеса.Добавить(ВидБизнесаОписание);
	
	ВидБизнесаОписание = Новый Структура;
	ВидБизнесаОписание.Вставить("Представление", НСтр("ru='Производство'"));
	ВидБизнесаОписание.Вставить("Код",           "Производство");
	ВидБизнесаОписание.Вставить("Идентификатор", "123040c0-72e1-4eeb-b4c5-fc7d9ecb1e0a");
	ВидыБизнеса.Добавить(ВидБизнесаОписание);
	
	Возврат ВидыБизнеса;
	
КонецФункции

Функция ИдентификаторВидаБизнеса(ВыбранныйВидБизнеса)
	
	ВидыБизнеса = ВидыБизнеса();
	
	Для каждого ВидБизнеса Из ВидыБизнеса Цикл
		Если ВидБизнеса.Код = ВыбранныйВидБизнеса Тогда
			Возврат ВидБизнеса.Идентификатор;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти