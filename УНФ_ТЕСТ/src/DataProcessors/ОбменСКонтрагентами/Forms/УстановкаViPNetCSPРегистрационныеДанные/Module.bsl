#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьРегистрационныеДанные();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ЭлектроннаяПочта)
		И Не ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлектроннаяПочта) Тогда
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Некорректно заполнен адрес электронной почты.'"),, "ЭлектроннаяПочта",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ПараметрыРегистрации = Новый Структура;
		ПараметрыРегистрации.Вставить("КонтактноеЛицо", СокрЛП(КонтактноеЛицо));
		ПараметрыРегистрации.Вставить("ЭлектроннаяПочта", СокрЛП(ЭлектроннаяПочта));
		ПараметрыРегистрации.Вставить("СерийныйНомер", "");
		ПараметрыРегистрации.Вставить("Продукт", "");
		ПараметрыРегистрации.Вставить("ВыполнятьКонтрольЦелостности", ВыполнятьКонтрольЦелостности);
		ПараметрыРегистрации.Вставить("ИмяПрограммы", НСтр("ru = 'VipNet CSP'"));
		
		Закрыть(ПараметрыРегистрации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьРегистрационныеДанные()

	ТекущийПользователь = Пользователи.ТекущийПользователь();
	КонтактноеЛицо = ТекущийПользователь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПользователиКонтактнаяИнформация.Представление
	|ИЗ
	|	Справочник.Пользователи.КонтактнаяИнформация КАК ПользователиКонтактнаяИнформация
	|ГДЕ
	|	ПользователиКонтактнаяИнформация.Ссылка = &Ссылка
	|	И ПользователиКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EmailПользователя)";
	Запрос.УстановитьПараметр("Ссылка", ТекущийПользователь);
	Результат = Запрос.Выполнить();
	Если Не Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
	
		Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(Выборка.Представление) Тогда
			ЭлектроннаяПочта = Выборка.Представление;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

